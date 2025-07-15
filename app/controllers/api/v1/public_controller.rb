class Api::V1::PublicController < ApplicationController
  # Rails 7+ built-in rate limiting
  # rate_limit to: 5, within: 1.minute, only: :index

  def index
    render json: { 
      message: "Public endpoint",
      rate_limit: {
        limit: response.headers.try(:[], 'X-RateLimit-Limit') || 5,
        remaining: response.headers.try(:[], 'X-RateLimit-Remaining') || 5
      }
    }
  end
end
