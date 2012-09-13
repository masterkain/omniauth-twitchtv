require 'bundler/setup'
require 'sinatra/base'
require 'omniauth-twitchtv'

class App < Sinatra::Base
  get '/' do
    redirect '/auth/twitchtv'
  end

  get '/auth/:provider/callback' do
    content_type 'application/json'
    MultiJson.encode(request.env)
  end

  get '/auth/failure' do
    content_type 'application/json'
    MultiJson.encode(request.env)
  end
end

use Rack::Session::Cookie

use OmniAuth::Builder do
  #note that the scope is different from the default
  #we also have to repeat the default fields in order to get
  #the extra 'connections' field in there
  provider :twitchtv, ENV['TWITCHTV_CONSUMER_KEY'], :scope => 'channel_read'
end

run App.new
