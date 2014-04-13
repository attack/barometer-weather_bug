require_relative 'query'

module Barometer
  class WeatherBug
    class CurrentApi < Utils::Api
      def initialize(query, api_code)
        @query = WeatherBug::Query.new(query)
        @api_code = api_code
      end

      def url
        "http://#{@api_code}.api.wxbug.net/getLiveWeatherRSS.aspx"
      end

      def params
        {ACode: @api_code, OutputType: '1'}.merge(@query.to_param)
      end

      def unwrap_nodes
        ['weather', 'ob']
      end
    end
  end
end
