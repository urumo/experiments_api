# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins' do
  describe 'GET /index' do
    it 'returns http success' do
      get '/admin/index'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /authenticate' do
    it 'returns http success' do
      get '/admin/authenticate'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /create_user' do
    it 'returns http success' do
      get '/admin/create_user'
      expect(response).to have_http_status(:success)
    end
  end
end
