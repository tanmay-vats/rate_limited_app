# spec/requests/rate_limiting_spec.rb
require 'rails_helper'

RSpec.describe "API Rate Limiting", type: :request do
  let(:ip) { '1.2.3.4' }

  describe 'GET /api/v1/public' do
    it 'works with basic request' do
      get '/api/v1/public', env: { 'REMOTE_ADDR' => ip }
      expect(response).not_to be_nil
      expect(response).to have_http_status(:ok)
    end

    context 'rate limiting' do
      before do
        # Make 5 requests to hit limit
        5.times { get '/api/v1/public', env: { 'REMOTE_ADDR' => ip } }
      end

      it 'throttles after limit' do
        get '/api/v1/public', env: { 'REMOTE_ADDR' => ip }
        expect(response).to have_http_status(:too_many_requests)
      end
    end
  end
end
