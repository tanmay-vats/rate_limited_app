module RateLimitable
  extend ActiveSupport::Concern

  included do
    before_action :set_rate_limit_headers
  end

  private

  def set_rate_limit_headers
    throttle_data = request.env['rack.attack.throttle_data'] || {}
    active_limit = throttle_data.values.first # Get the first throttle

    return unless active_limit

    response.headers['X-RateLimit-Limit'] = active_limit[:limit].to_s
    response.headers['X-RateLimit-Remaining'] = (active_limit[:limit].to_i - active_limit[:count].to_i).to_s
    response.headers['X-RateLimit-Reset'] = (active_limit[:epoch_time] + active_limit[:period]).to_s
  end
end
