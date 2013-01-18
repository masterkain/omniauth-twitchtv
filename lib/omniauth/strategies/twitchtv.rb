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

      uid do
        access_token.token
      end

      info do
        {
          name: raw_info["name"]
        }
      end

      def raw_info
        get_hash_from_channel = lambda do |token|
          http_client = HTTPClient.new
          header = {"Authorization"=>"OAuth #{token}"}
          response = http_client.get(info_url, "", header)
          if response.code != "200"
            raise Omniauth::Twitchtv::TwitchtvError.new("Failed to get user details from twitchtv")
          end
          response
        end
        @raw_info ||= JSON.parse(get_hash_from_channel.call(access_token.token).body)
      end

      def info_url
        url = if self.options.scopes && (self.options.scopes.index("user_read") || self.options.scopes.index(:user_read)) then
          "https://api.twitch.tv/kraken/user"
        elsif self.options.scopes && (self.options.scopes.index("channel_read") || self.options.scopes.index(:channel_read)) then
          "https://api.twitch.tv/kraken/channel"
        elsif self.options.scope.to_sym == :user_read then
          "https://api.twitch.tv/kraken/user"
        elsif self.options.scope.to_sym == :channel_read then
          "https://api.twitch.tv/kraken/channel"
        else
          raise Omniauth::Twitchtv::TwitchtvError.new("Must include at least either the channel or user read scope in omniauth-twitchtv initializer")
        end
        url
      end
    end
  end
end
OmniAuth.config.add_camelization 'twitchtv', 'Twitchtv'

