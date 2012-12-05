require 'sidekiq'
require 'yaml'

require './workers/new_tweet'
require './workers/reply_tweet'
require './workers/retweet'

config = YAML.load_file('config.yml')

# Sidekiq server is multi-threaded so our Redis connection pool size defaults to concurrency (-c)
Sidekiq.configure_server do |c|
  c.redis = { :namespace => config['sidekiq']['namespace'], :url => config['sidekiq']['url'] }
end

# Start up sidekiq via
# ./bin/sidekiq -r ./examples/por.rb
#

Sidekiq.configure_client do |c|
  c.redis = { :namespace => config['sidekiq']['namespace'], :url => config['sidekiq']['url']}
end

