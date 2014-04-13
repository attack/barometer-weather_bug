require_relative 'query'

module Barometer
  class WeatherBug
    class CurrentApi < Utils::Api
      def initialize(query, oauth_token)
        @query = WeatherBug::Query.new(query)
        @oauth_token = oauth_token
      end

      def url
        'https://thepulseapi.earthnetworks.com/data/observations/v1/current'
      end

      def params
        oauth2_params.merge(@query.to_param)
      end

      private

      attr_reader :oauth_token

      def oauth2_params
        { access_token: oauth_token.access_token }
      end
    end
  end
end
