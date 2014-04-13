require_relative '../spec_helper'

module Barometer
  describe WeatherBug::Query do
    describe '#to_param' do
      let(:converted_query) { double(:converted_query).as_null_object }
      let(:query) { WeatherBug::Query.new(converted_query) }

      context 'and the query is a :coordinates' do
        let(:geo) { double(:geo, latitude: '11.22', longitude: '33.44') }
        before { converted_query.stub(format: :coordinates, geo: geo) }

        it 'includes the correct parameters' do
          expect( query.to_param[:locationtype] ).to eq 'latitudelongitude'
          expect( query.to_param[:location] ).to eq '11.22,33.44'
        end
      end

      context 'and the query is metric' do
        before { converted_query.stub(metric?: true) }

        it 'includes the correct parameters' do
          expect( query.to_param[:units] ).to eq 'metric'
        end
      end

      context 'and the query is imperial' do
        before { converted_query.stub(metric?: false) }

        it 'includes the correct parameters' do
          expect( query.to_param[:units] ).to eq 'english'
        end
      end
    end
  end
end
