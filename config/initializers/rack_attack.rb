class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  # Throttle requests by IP - use proper request methods
  throttle('api/ip', limit: 5, period: 1.minute) do |req|
    # Use get_header instead of [] access
    req.get_header('REMOTE_ADDR') if req.path.start_with?('/api/v1')
  end

  # Custom throttled response
  self.throttled_responder = lambda do |request|
    match_data = request.env['rack.attack.match_data']
    now = match_data[:epoch_time]
    reset_time = (now + match_data[:period]).to_i
    limit = match_data[:limit].to_i

    headers = {
      'Content-Type' => 'application/json',
      'RateLimit-Limit' => limit.to_s,
      'RateLimit-Remaining' => match_data[:count].to_i - limit,
      'RateLimit-Reset' => (now + (match_data[:period] - now % match_data[:period])).to_s,
      'Retry-After' => (match_data[:period] - (now % match_data[:period])).to_s
    }

    [ 429, headers, [{ error: "Rate limit exceeded. Try again at #{Time.at(reset_time)}" }.to_json]]
  end
end
