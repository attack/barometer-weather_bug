module Barometer
  class WeatherBug
    class Response
      class ForecastedWeather
        def initialize(payload)
          @payload = payload
          @predictions = Barometer::Response::PredictionCollection.new
        end

        def parse
          each_prediction do |prediction, forecast_payload, index|
            prediction.starts_at = starts_at(forecast_payload)
            prediction.ends_at = ends_at(prediction.starts_at)
            prediction.condition = condition(forecast_payload)
            prediction.icon = icon(forecast_payload)
            prediction.pop = pop(forecast_payload)

            if is_day?(forecast_payload)
              prediction.high = high(forecast_payload)
            else
              prediction.low = low(forecast_payload)
            end
          end

          predictions
        end

        private

        attr_reader :payload, :predictions

        def units
          payload.units
        end

        def each_prediction
          payload.fetch_each_with_index('dailyForecastPeriods') do |forecast_payload, index|
            predictions.build do |prediction|
              yield prediction, forecast_payload, index
            end
          end
        end

        def starts_at(forecast_payload)
          Utils::Time.parse(forecast_payload.fetch('forecastDateUtcStr'), '%Y-%m-%dT%H:%M:%S%z')
        end

        def ends_at(starts_at)
          half_a_day_minus_one_second = (12 * 60 * 60 - 1)
          starts_at + half_a_day_minus_one_second
        end

        def condition(forecast_payload)
          forecast_payload.fetch('summaryDescription')
        end

        def icon(forecast_payload)
          forecast_payload.fetch('iconCode')
        end

        def high(forecast_payload)
          [units, forecast_payload.fetch('temperature')]
        end

        def low(forecast_payload)
          [units, forecast_payload.fetch('temperature')]
        end

        def pop(forecast_payload)
          forecast_payload.fetch('precipProbability')
        end

        def is_day?(forecast_payload)
          !forecast_payload.fetch('isNightTimePeriod')
        end
      end
    end
  end
end
