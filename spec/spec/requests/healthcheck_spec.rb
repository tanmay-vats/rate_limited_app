require 'rails_helper'

RSpec.describe "Health Check", type: :request do
  it 'works without Rack::Attack' do
    Rack::Attack.enabled = false
    get '/api/v1/public'
    expect(response).not_to be_nil
    expect(response).to have_http_status(:ok)
  end

  it 'works with Rack::Attack' do
    Rack::Attack.enabled = true
    get '/api/v1/public'
    expect(response).not_to be_nil
    expect(response).to have_http_status(:ok)
  end
end
