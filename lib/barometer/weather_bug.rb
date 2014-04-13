require 'barometer'
require_relative 'weather_bug/version'
require_relative 'weather_bug/oauth_api'
require_relative 'weather_bug/oauth_token'
require_relative 'weather_bug/current_api'
require_relative 'weather_bug/current_response'
require_relative 'weather_bug/forecast_api'
require_relative 'weather_bug/forecast_response'

module Barometer
  class WeatherBug
    def self.call(query, config={})
      WeatherBug.new(query, config).measure!
    end

    def initialize(query, config={})
      @query = query

      if config.has_key? :keys
        @api_client_id = config[:keys][:client_id]
        @api_client_secret = config[:keys][:client_secret]
      end
    end

    def measure!
      validate_keys!

      oauth_token_api = OauthApi.new(api_client_id, api_client_secret)
      oauth_token = OauthToken.new(oauth_token_api)

      current_weather_api = CurrentApi.new(query, oauth_token)
      response = CurrentResponse.new.parse(current_weather_api.get)

      forecast_weather_api = ForecastApi.new(current_weather_api.query, oauth_token)
      ForecastResponse.new(response).parse(forecast_weather_api.get)
    end

    private

    attr_reader :query, :api_client_id, :api_client_secret

    def validate_keys!
      unless api_client_id && api_client_secret
        raise Barometer::WeatherService::KeyRequired
      end
    end
  end
end

Barometer::WeatherService.register(:weather_bug, Barometer::WeatherBug)
