# sidekiq_config = { url: ENV['JOB_WORKER_URL'] }

Sidekiq.configure_server do |config|
  # config.redis = sidekiq_config
  config.redis = { url: 'redis://redis:6379/0' }
end

Sidekiq.configure_client do |config|
  # config.redis = sidekiq_config
  config.redis = { url: 'redis://redis:6379/0' }
end
