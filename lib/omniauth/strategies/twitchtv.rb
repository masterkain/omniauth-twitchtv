require 'omniauth/strategies/oauth'

module OmniAuth
  module Strategies
    class Twitchtv
      include OmniAuth::Strategy

      option :name, "twitchtv"

      args [:client_id]

      option :client_id, nil
      option :client_options, {
        :site          => 'https://api.twitch.tv',
        :api_url       => 'https://api.twitch.tv/kraken',
        :authorize_url => '/kraken/oauth2/authorize',
        :proxy         => ENV['http_proxy'] ? URI(ENV['http_proxy']) : nil,
        :callback      => nil
      }
      option :authorize_params, {}
      option :authorize_options, [:scope, :response_type]
      option :response_type, 'token'

      attr_accessor :json
      attr_accessor :access_token

      def client
        ::OAuth2::Client.new(options.client_id, nil, deep_symbolize(options.client_options))
      end

      def callback_url
        options.client_options.callback || full_host + script_name + callback_path
      end

      def request_phase
        redirect client.auth_code.authorize_url({:redirect_uri => callback_url}.merge(authorize_params))
      end

      def authorize_params
        options.authorize_params.merge(options.authorize_options.inject({}){|h,k| h[k.to_sym] = options[k] if options[k]; h})
      end

      def callback_phase
        if request.params['error'] || request.params['error_reason']
          raise CallbackError.new(request.params['error'], request.params['error_description'] || request.params['error_reason'], request.params['error_uri'])
        end

        @json = {}
        self.access_token = request.params["access_token"]
        begin
          response = RestClient.get("#{options.client_options.api_url}/user", { 'Authorization' => "OAuth #{access_token}" })
          user = MultiJson.decode(response.to_s)
          #  {
          #              "name" => "xxx",
          #        "created_at" => "2011-11-17T02:15:55Z",
          #        "updated_at" => "2012-09-12T08:40:39Z",
          #              "logo" => nil,
          #            "_links" => {
          #          "self" => "https://api.twitch.tv/kraken/users/xxx"
          #      },
          #             "staff" => false,
          #               "_id" => 26190497,
          #      "display_name" => "xxx",
          #             "email" => "xxx@gmail.com"
          #  }
          @json.merge!(user)
          super
        rescue CallbackError, ::RestClient::Exception => e
          fail!(:invalid_credentials, e)
        rescue ::MultiJson::DecodeError => e
          fail!(:invalid_response, e)
        rescue ::Timeout::Error, ::Errno::ETIMEDOUT => e
          fail!(:timeout, e)
        rescue ::SocketError => e
          fail!
        end
      end

      credentials do
        {'token' => access_token}
      end

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

      protected

      def deep_symbolize(hash)
        hash.inject({}) do |h, (k,v)|
          h[k.to_sym] = v.is_a?(Hash) ? deep_symbolize(v) : v
          h
        end
      end

      def build_access_token
        verifier = request.params['code']
        client.auth_code.get_token(verifier, {:redirect_uri => callback_url}.merge(token_params.to_hash(:symbolize_keys => true)))
      end

      # An error that is indicated in the OAuth 2.0 callback.
      # This could be a `redirect_uri_mismatch` or other
      class CallbackError < StandardError
        attr_accessor :error, :error_reason, :error_uri

        def initialize(error, error_reason=nil, error_uri=nil)
          self.error = error
          self.error_reason = error_reason
          self.error_uri = error_uri
        end
      end

    end
  end
end
OmniAuth.config.add_camelization 'twitchtv', 'Twitchtv'
