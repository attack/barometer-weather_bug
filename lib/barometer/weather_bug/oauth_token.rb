
require_relative 'query'

module Barometer
  class WeatherBug
    class OauthToken
      def initialize(oauth_token_api)
        @oauth_token_api = oauth_token_api
        @access_token = nil
        @expires_at = nil
      end

      def access_token
        refresh_token if stale_token?
        @access_token
      end

      private

      def stale_token?
        @access_token == nil || @expires_at == nil ||
          @expires_at < Time.now.utc
      end

      def refresh_token
        response = @oauth_token_api.get
        @access_token = response.fetch(:token)
        @expires_at = Time.now.utc + response.fetch(:expires_in)
      end
    end
  end
end
