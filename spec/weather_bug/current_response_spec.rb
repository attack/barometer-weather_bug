require_relative '../spec_helper'

module Barometer
  describe WeatherBug::CurrentResponse do
    it "parses the timezones correctly" do
      payload = Barometer::Utils::Payload.new(
        'observationTimeUtcStr' => '2013-05-18T17:46:00'
      )
      response = WeatherBug::CurrentResponse.new.parse(payload)

      utc_observed_at = Time.utc(2013,5,18,17,46,0)

      expect( response.current.observed_at.utc ).to eq utc_observed_at
    end
  end
end
