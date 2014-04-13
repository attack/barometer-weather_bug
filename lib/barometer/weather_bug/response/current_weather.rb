module Barometer
  class WeatherBug
    class Response
      class CurrentWeather
        def initialize(payload)
          @payload = payload
          @current = Barometer::Response::Current.new
        end

        def parse
          current.observed_at = observed_at
          current.humidity = humidity
          current.icon = icon
          current.temperature = temperature
          current.dew_point = dew_point
          current.wind = wind

          current
        end

        private

        attr_reader :payload, :current

        def units
          payload.units
        end

        def observed_at
          Utils::Time.parse(payload.fetch('observationTimeUtcStr'), '%Y-%m-%dT%H:%M:%S')
        end

        def humidity
          payload.fetch('humidity')
        end

        def icon
          payload.fetch('iconCode')
        end

        def temperature
          [units, payload.fetch('temperature')]
        end

        def dew_point
          [units, payload.fetch('dewPoint')]
        end

        def wind
          [units, payload.fetch('windSpeed'), payload.fetch('windDirection')]
        end
      end
    end
  end
end
