require_relative 'spec_helper'

module Barometer
  describe WeatherBug, vcr: {
    cassette_name: 'WeatherService::WeatherBug'
  } do

    it 'auto-registers this weather service as :weather_bug' do
      expect( Barometer::WeatherService.source(:weather_bug) ).to eq Barometer::WeatherBug
    end

    describe '.call' do
      context 'when no keys are provided' do
        let(:query) { build_query }

        it 'raises an error' do
          expect {
            WeatherBug.call(query)
          }.to raise_error(Barometer::WeatherService::KeyRequired)
        end
      end

      context 'when keys are provided' do
        let(:converted_query) { ConvertedQuery.new('90210', :short_zipcode, :metric) }
        let(:query) { build_query.tap{|q|q.stub(:convert! => converted_query)} }
        let(:config) { {keys: {code: WEATHERBUG_CODE}} }

        subject { WeatherBug.call(query, config) }

        it 'converts the query to accepted formats' do
          subject
          expect( query ).to have_received(:convert!).with(:short_zipcode, :coordinates).at_least(:once)
        end

        it 'includes the expected data' do
          expect( subject.query ).to eq '90210'
          expect( subject.format ).to eq :short_zipcode
          expect( subject ).to be_metric

          should have_data(:current, :observed_at).as_format(:time)
          should have_data(:current, :stale_at).as_format(:time)

          should have_data(:current, :humidity).as_format(:float)
          should have_data(:current, :condition).as_format(:string)
          should have_data(:current, :icon).as_format(:number)
          should have_data(:current, :temperature).as_format(:temperature)
          should have_data(:current, :dew_point).as_format(:temperature)
          should have_data(:current, :wind_chill).as_format(:temperature)
          should have_data(:current, :wind).as_format(:vector)
          should have_data(:current, :pressure).as_format(:pressure)
          should have_data(:current, :sun, :rise).as_format(:time)
          should have_data(:current, :sun, :set).as_format(:time)

          should have_data(:station, :id).as_value('NRTSH')
          should have_data(:station, :name).as_value('Campbell Hall School')
          should have_data(:station, :city).as_value('Valley Village')
          should have_data(:station, :state_code).as_value('CA')
          should have_data(:station, :country).as_value('USA')
          should have_data(:station, :zip_code).as_value('91617')
          should have_data(:station, :latitude).as_value(34.1536102294922)
          should have_data(:station, :longitude).as_value(-118.398056030273)

          should have_data(:location, :city).as_value('Beverly Hills')
          should have_data(:location, :state_code).as_value('CA')
          should have_data(:location, :zip_code).as_value('90210')

          should have_data(:timezone, :to_s).as_format(/^P[DS]T$/i)

          expect( subject.forecast.size ).to eq 7
          should have_forecast(:starts_at).as_format(:time)
          should have_forecast(:ends_at).as_format(:time)
          should have_forecast(:condition).as_format(:string)
          should have_forecast(:icon).as_format(:number)
          should have_forecast(:high).as_format(:temperature)
          should have_forecast(:low).as_format(:temperature)
        end
      end
    end
  end
end
