require 'sidekiq'
require 'yaml'

config = YAML.load_file('config.yml')

Sidekiq.configure_client do |c|
  c.redis = { :namespace => config['sidekiq']['namespace'], :url => config['sidekiq']['url']}
end

class NewTweet
  include Sidekiq::Worker

  def perform(msg='un msg')
    sleep 10
    puts msg
  end
end
