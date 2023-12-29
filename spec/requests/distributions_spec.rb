# frozen_string_literal: true

require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Distributions' do
  let(:url) { '/api/distribution' }

  describe 'GET /api/distribution' do
    context 'without Device-Token header' do
      it 'returns 400' do
        get url
        expect(response).to have_http_status(:internal_server_error)
      end
    end

    context 'with Device-Token header' do
      let(:device_id) { SecureRandom.uuid }

      it 'returns exact distribution for sequential case' do
        Experiment.create(key: 'button_color', value: '#FF0000', chance: 33.3)
        Experiment.create(key: 'button_color', value: '#00FF00', chance: 33.3)
        Experiment.create(key: 'button_color', value: '#0000FF', chance: 33.3)
        tokens = Array.new(600) { SecureRandom.uuid }
        results = tokens.map do |token|
          get(url, headers: { 'Device-Token' => token })
          response.body
        end

        parsed = results.map { |result| JSON.parse(result) }
        counts = parsed.group_by { |i| i.dig('device', 'experiments', 0, 'value') }.values.map(&:size)
        expect(counts).to all(be_eql(200))
      end

      it 'returns exact distribution for parallel case' do
        Experiment.create(key: 'button_color', value: '#FF0000', chance: 33.3)
        Experiment.create(key: 'button_color', value: '#00FF00', chance: 33.3)
        Experiment.create(key: 'button_color', value: '#0000FF', chance: 33.3)
        tokens = Array.new(600) { SecureRandom.uuid }
        results = Parallel.map(tokens, in_processes: 4) do |token|
          get(url, headers: { 'Device-Token' => token })
          response.body
        end

        parsed = results.map { |result| JSON.parse(result) }
        counts = parsed.group_by { |i| i.dig('device', 'experiments', 0, 'value') }.values.map(&:size)
        expect(counts).to all(be_eql(200))
      end

      it 'returns device as dto' do
        get url, headers: { 'Device-Token' => device_id }
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ device: { device_token: device_id, user: nil, experiments: [] } }.to_json)
      end

      it 'returns device with experiments' do
        Experiment.create(key: 'key', value: 'a', chance: 50)
        Experiment.create(key: 'key', value: 'b', chance: 50)

        get url, headers: { 'Device-Token' => device_id }

        expect(response).to have_http_status(:ok)

        body = response.parsed_body

        expect(body['device']['device_token']).to eq(device_id)

        expect(body['device']['user']).to be_nil

        expect(body['device']['experiments'].size).to eq(1)

        expect(Experiment.pluck(:value)).to include(body['device']['experiments'][0]['value'])
      end
    end
  end

  path '/api/distribution' do
    get 'Get distribution' do
      tags 'Distribution'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :device_token, in: :header, type: :string, required: true

      response '200', 'distribution' do
        schema type: :object,
               properties: {
                 device: {
                   type: :object,
                   properties: {
                     device_token: { type: :string },
                     user: {
                       type: :object, 'x-nullable': true,
                       properties: {
                         id: { type: :string },
                         email: { type: :string },
                         role: { type: :string }
                       }
                     },
                     experiments: {
                       type: :array,
                       items: {
                         type: :object,
                         properties: {
                           key: { type: :string },
                           value: { type: :string }
                         },
                         required: %w[key value]
                       }
                     }
                   },
                   required: %w[device_token experiments]
                 }
               }
        let(:device_token) { SecureRandom.uuid }
        run_test!
      end

      response '500', 'invalid request' do
        schema type: :object,
               properties: {
                 error: {
                   type: :object,
                   properties: {
                     error_type: { type: :string },
                     error_message: { type: :string },
                     error_backtrace: {
                       type: :array,
                       items: { type: :string }
                     }
                   }
                 }
               }
        let(:device_token) { nil }
        run_test!
      end
    end
  end
end
