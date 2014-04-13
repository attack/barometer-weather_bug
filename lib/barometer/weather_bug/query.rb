require 'delegate'

module Barometer
  class WeatherBug
    class Query < SimpleDelegator
      attr_reader :converted_query

      def self.accepted_formats
        [:coordinates]
      end

      def initialize(query)
        super
        @converted_query = convert_query
      end

      def to_param
        {
          locationtype: location_type,
          units: units,
          verbose: 'true'
        }.merge(format_query)
      end

      private

      def convert_query
        convert!(*self.class.accepted_formats)
      end

      def location_type
        'latitudelongitude'
      end

      def units
        converted_query.metric? ? 'metric' : 'english'
      end

      def format_query
        if converted_query.geo
          { location: "#{converted_query.geo.latitude},#{converted_query.geo.longitude}" }
        else
          { location: converted_query.to_s }
        end
      end
    end
  end
end
