require 'sidekiq'
require 'yaml'

config = YAML.load_file('config.yml')

Sidekiq.configure_client do |c|
  c.redis = { :namespace => config['sidekiq']['namespace'], :url => config['sidekiq']['url']}
end

class ReplyTweet
  include Sidekiq::Worker

  def perform(status)
    unless status.attrs[:entities].nil? ||
      status.attrs[:entities][:media].nil? ||
      status.attrs[:entities][:media].empty?
      # TODO: Acá media es un array que puede tener varias imágenes
      img = status.attrs[:entities][:media][0][:media_url]
    else
      img = nil
    end

    url = @config['api_host'] + '/twitter/reply'
    data = {
      message: status.attrs[:text],
      tweet_id: status.attrs[:id_str],
      reply_to_id: status.attrs[:in_reply_to_status_id_str],
      user_id: status.attrs[:user][:id_str],
      image_url: img,
    }

    puts data
  end
end
