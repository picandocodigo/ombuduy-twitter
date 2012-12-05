require 'sidekiq'
require 'yaml'

config = YAML.load_file('config.yml')

Sidekiq.configure_client do |c|
  c.redis = { :namespace => config['sidekiq']['namespace'], :url => config['sidekiq']['url']}
end

class NewTweet
  include Sidekiq::Worker

  def perform(status)

    if status.attrs[:geo]
      case status.attrs[:geo][:type]
      when "Point" then
        latitude = status.attrs[:geo][:coordinates][0].to_s
        longitude = status.attrs[:geo][:coordinates][1].to_s
      when "Polygon" then
        center = Geocoder::Calculations.geographic_center(
                                                          status.attrs[:geo][:coordinates][0],
                                                          status.attrs[:geo][:coordinates][1],
                                                          status.attrs[:geo][:coordinates][2],
                                                          status.attrs[:geo][:coordinates][3]
                                                          )
        latitude, longitude = center[0].to_s, center[1].to_s
      end
    end

    unless status.attrs[:entities].nil? ||
            status.attrs[:entities][:media].nil? ||
            status.attrs[:entities][:media].empty?
      img = status.attrs[:entities][:media][0][:media_url]
    else
      img = nil
    end

    url = @config['api_host'] + '/twitter/new'
    data = {
      text: status.attrs[:text],
      image_url: img,
      latitude: latitude,
      longitude: longitude,
      tweet_id: status.attrs[:id_str],
      user_id: status.attrs[:user][:id_str]
    }

    puts data

  end
end
