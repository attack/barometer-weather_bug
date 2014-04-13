require_relative 'query'

module Barometer
  class WeatherBug
    class OauthApi < Utils::Api
      def initialize(api_client_id, api_client_secret)
        @api_client_id = api_client_id
        @api_client_secret = api_client_secret
      end

      def url
        'https://thepulseapi.earthnetworks.com/oauth20/token'
      end

      def params
        {
          grant_type: 'client_credentials',
          client_id: @api_client_id,
          client_secret: @api_client_secret
        }
      end

      def unwrap_nodes
        ['OAuth20', 'access_token']
      end
    end
  end
end
