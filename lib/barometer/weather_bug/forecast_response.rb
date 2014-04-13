require_relative 'response/forecasted_weather'

module Barometer
  class WeatherBug
    class ForecastResponse
      def initialize(response)
        @response = response
      end

      def parse(payload)
        response.forecast = WeatherBug::Response::ForecastedWeather.new(payload).parse
        response
      end

      private

      attr_reader :response
    end
  end
end
