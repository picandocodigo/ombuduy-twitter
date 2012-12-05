require 'sidekiq'
require 'yaml'

config = YAML.load_file('config.yml')

Sidekiq.configure_client do |c|
  c.redis = { :namespace => config['sidekiq']['namespace'], :url => config['sidekiq']['url']}
end

class Retweet
  include Sidekiq::Worker

  def perform(status)

    url = @config['api_host'] + '/twitter/rt'
    data = {
      tweet_id: status.attrs[:retweeted_status][:id_str]
    }

    puts data
  end
end
