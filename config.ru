require 'sidekiq'
require 'yaml'

config = YAML.load_file('config.yml')

Sidekiq.configure_client do |c|
  c.redis = { :namespace => config['sidekiq']['namespace'], :url => config['sidekiq']['url'], :size => 1}
end

require 'sidekiq/web'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == config['sidekiq']['webuser'] && password == config['sidekiq']['webpass']
end 

run Sidekiq::Web

