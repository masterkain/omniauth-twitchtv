require 'omniauth/strategies/oauth'

module OmniAuth
  module Strategies
    class Twitchtv < OmniAuth::Strategies::OAuth2
      option :name, "twitchtv"

      args [:client_id]

      option :client_options, {
        :site          => 'https://api.twitch.tv',
        :api_url       => 'https://api.twitch.tv/kraken',
        :authorize_url => '/kraken/oauth2/authorize',
        :proxy         => ENV['http_proxy'] ? URI(ENV['http_proxy']) : nil,
        :callback      => nil
      }

      option :response_type, 'token'
      option :authorize_options, [:scope, :response_type]

      attr_reader :json

      uid do
        @json['_id']
      end

      info do
        {
          :email    => @json['email'],
          :nickname => @json['display_name']
        }
      end

      extra do
        { 'raw_info' => @json }
      end

      def callback_url
        options.client_options.callback || super
      end

      def callback_phase
        @json = {}
        token = request.params["access_token"]
        begin
          response = RestClient.get("#{options.client_options.api_url}/user", { 'Authorization' => "OAuth #{token}" })
          user = MultiJson.decode(response.to_s)
          ap user
          @json.merge!(user)
        rescue ::RestClient::Exception => e
          raise ::Timeout::Error
        end
        super
      end

      def raw_info
        @raw_info ||= MultiJson.decode(access_token.get("/user").body)
        @raw_info
      end
    end
  end
end

OmniAuth.config.add_camelization 'twitchtv', 'Twitchtv'
