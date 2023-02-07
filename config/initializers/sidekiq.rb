# frozen_string_literal: true

require "sidekiq"

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("CATPURR_ONE_APP_SIDEKIQ_REDIS_URL", nil) }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("CATPURR_ONE_APP_SIDEKIQ_REDIS_URL", nil) }
end
