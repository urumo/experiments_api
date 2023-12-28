# frozen_string_literal: true

require 'rails_helper'

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
end
