class Api::V1::PublicController < ApplicationController
  # Rails 7+ built-in rate limiting
  # rate_limit to: 5, within: 1.minute, only: :index

  def index
    render json: {
      message: "Public endpoint",
      rate_limit: {
        limit: response.headers['X-RateLimit-Limit'],
        remaining: response.headers['X-RateLimit-Remaining'],
        reset: response.headers['X-RateLimit-Reset']
      }
    }
  end
end
