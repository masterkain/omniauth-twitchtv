require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Twitchtv < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => 'https://api.twitch.tv',
        :authorize_url => 'https://api.twitch.tv/kraken/oauth2/authorize',
        :token_url => 'https://api.twitch.tv/kraken/oauth2/token'
      }


      option :authorize_params, {}
      option :authorize_options, [:scope, :response_type]
      option :response_type, 'code'
    end
  end
end
OmniAuth.config.add_camelization 'twitchtv', 'Twitchtv'

