require_relative '../spec_helper'

module Barometer
  describe WeatherBug::ForecastResponse do
    let(:current_response) { Barometer::Response.new }

    it "parses the timezones correctly" do
      payload = Barometer::Utils::Payload.new(
        "dailyForecastPeriods" => [
          "forecastDateUtcStr" => "2014-04-13T23:00:00Z"
        ]
      )
      response = WeatherBug::ForecastResponse.new(current_response).parse(payload)

      utc_starts_at = Time.utc(2014,4,13,23,0,0)
      utc_ends_at = Time.utc(2014,4,14,10,59,59)

      expect( response.forecast[0].starts_at.utc ).to eq utc_starts_at
      expect( response.forecast[0].ends_at.utc ).to eq utc_ends_at
    end
  end
end
