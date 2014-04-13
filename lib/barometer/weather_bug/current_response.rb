require_relative 'response/current_weather'

module Barometer
  class WeatherBug
    class CurrentResponse
      def initialize
        @response = Barometer::Response.new
      end

      def parse(payload)
        response.add_query(payload.query)
        response.current = WeatherBug::Response::CurrentWeather.new(payload).parse
        response
      end

      private

      attr_reader :response
    end
  end
end
