require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Twitchtv < OmniAuth::Strategies::OAuth2
      option :name, 'twitchtv'

      option :client_options, {
        :site => 'https://api.twitch.tv',
        :authorize_url => 'https://api.twitch.tv/kraken/oauth2/authorize',
        :token_url => 'https://api.twitch.tv/kraken/oauth2/token'
      }


      option :authorize_params, {}
      option :authorize_options, [:scope, :response_type]
      option :response_type, 'code'

      uid do
        raw_info['_id']
      end

      info do
        {
          name: raw_info['name'],
          email: raw_info['email'],
          nickname: raw_info['display_name'],
          image: raw_info['logo'],
          urls: {
            channel: raw_info['_links']['self']
          }
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        access_token.options[:header_format] = 'OAuth %s'
        @raw_info ||= access_token.get(info_url).parsed
      end

      def info_url
        unless self.options.scopes && (self.options.scopes.index("user_read") || self.options.scopes.index(:user_read)) ||
            self.options.scopes && (self.options.scopes.index("user_read") || self.options.scopes.index(:user_read)) ||
            self.options.scope.to_sym == :user_read || self.options.scope.to_sym == :channel_read
          raise Omniauth::Twitchtv::TwitchtvError.new("Must include at least either the channel or user read scope in omniauth-twitchtv initializer")
        end
        "https://api.twitch.tv/kraken/user"
      end
    end
  end
end
OmniAuth.config.add_camelization 'twitchtv', 'Twitchtv'
