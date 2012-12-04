require 'tweetstream'
require 'yaml'

class Array
  def extract_options!
    if last.is_a?(Hash) && last.extractable_options?
      pop
    else
      {}
    end
  end
end

config = YAML.load_file('config.yml')

TweetStream.configure do |c|
  c.consumer_key       = config['twitter']['consumer_key'] 
  c.consumer_secret    = config['twitter']['consumer_secret']
  c.oauth_token        = config['twitter']['oauth_token']
  c.oauth_token_secret = config['twitter']['oauth_token_secret']
  c.auth_method        = :oauth
end

TweetStream::Daemon.new('feeder', :log_output => true, :multiple => true).track(config['twitter']['hashtags']) do |status|
  unless status.attrs[:user][:screen_name] == 'ombuduy' 
    if status.attrs[:retweeted_status] 
      puts 'es un retweet'
    elsif status.attrs[:in_reply_to_status_id_str] 
      puts 'es un reply'
    else 
      puts 'es uno nuevo'
    end
   end
end
