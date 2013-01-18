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

      def raw_info
        get_hash_from_channel = lambda do |token|
          http_client = HTTPClient.new
          header = {"Authorization"=>"OAuth #{token}"}
          http_client.get("https://api.twitch.tv/kraken/channel", "", header)
        end
        @channel_info || JSON.parse(get_hash_from_channel.call(access_token.token).body)
      end

      uid do
        access_token.token
      end

      info do
        {
          name: raw_info["name"]
        }
      end
    end
  end
end
OmniAuth.config.add_camelization 'twitchtv', 'Twitchtv'

