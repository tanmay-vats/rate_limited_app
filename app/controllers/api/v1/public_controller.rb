class Api::V1::PublicController < ApplicationController
  # Rails 7+ built-in rate limiting
  rate_limit to: 5, within: 1.minute, only: :index

  def index
  end
end
