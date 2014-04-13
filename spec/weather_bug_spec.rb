require_relative 'spec_helper'

module Barometer
  describe WeatherBug, vcr: {
    cassette_name: 'WeatherBug'
  } do

    it 'auto-registers this weather service as :weather_bug' do
      expect( Barometer::WeatherService.source(:weather_bug) ).to eq Barometer::WeatherBug
    end

    describe '.call' do
      let(:query) { build_query }

      context 'when no keys are provided' do
        it 'raises an error' do
          expect {
            WeatherBug.call(query)
          }.to raise_error(Barometer::WeatherService::KeyRequired)
        end
      end

      context 'when keys are provided' do
        let(:config) do
          {
            keys: {
              client_id: WEATHERBUG_CLIENT_ID,
              client_secret: WEATHERBUG_CLIENT_SECRET
            }
          }
        end
        let(:converted_query) do
          ConvertedQuery.new('39.1,77.1', :coordinates, :metric)
        end

        subject { WeatherBug.call(query, config) }

        before do
          allow(query).to receive(:convert!).with(:coordinates).
            and_return(converted_query)
        end

        it 'converts the query to accepted formats' do
          WeatherBug.call(query, config)

          expect(query).to have_received(:convert!).with(:coordinates).at_least(:once)
        end

        it 'includes the expected data' do
          result = WeatherBug.call(query, config)

          expect(result.query).to eq '39.1,77.1'
          expect(result.format).to eq :coordinates
          expect(result).to be_metric

          expect(result).to have_data(:current, :observed_at).as_format(:time)

          expect(result).to have_data(:current, :humidity).as_format(:float)
          expect(result).to have_data(:current, :icon).as_format(:number)
          expect(result).to have_data(:current, :temperature).as_format(:temperature)
          expect(result).to have_data(:current, :dew_point).as_format(:temperature)
          expect(result).to have_data(:current, :wind).as_format(:vector)

          expect( subject.forecast.size ).to eq 18

          day_forcast = subject.forecast.find{ |p| !p.high.nil? }
          expect(day_forcast).to have_data(:high).as_format(:temperature)
          expect(day_forcast).to have_data(:starts_at).as_format(:time)
          expect(day_forcast).to have_data(:ends_at).as_format(:time)
          expect(day_forcast).to have_data(:condition).as_format(:string)
          expect(day_forcast).to have_data(:icon).as_format(:number)
          expect(day_forcast).to have_data(:pop).as_format(:float)

          night_forcast = subject.forecast.find{ |p| !p.low.nil? }
          expect(night_forcast).to have_data(:low).as_format(:temperature)
          expect(night_forcast).to have_data(:starts_at).as_format(:time)
          expect(night_forcast).to have_data(:ends_at).as_format(:time)
          expect(night_forcast).to have_data(:condition).as_format(:string)
          expect(night_forcast).to have_data(:icon).as_format(:number)
          expect(night_forcast).to have_data(:pop).as_format(:float)
        end
      end
    end
  end
end
