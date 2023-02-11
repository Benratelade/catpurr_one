# Easiest way to run Sidekiq::Web.
# Run with "bundle exec rackup simple.ru"

require "sidekiq/web"

# A Web process always runs as client, no need to configure server
Sidekiq.configure_client do |config|
  config.redis = {url: ENV.fetch("CATPURR_ONE_APP_SIDEKIQ_REDIS_URL", nil), size: 1}
end

# In a multi-process deployment, all Web UI instances should share
# this secret key so they can all decode the encrypted browser cookies
# and provide a working session.
# Rails does this in /config/initializers/secret_token.rb
secret_key = SecureRandom.hex(32)
use Rack::Session::Cookie, secret: secret_key, same_site: true, max_age: 86400
run Sidekiq::Web