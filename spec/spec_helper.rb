require 'rspec'
require 'pry'
require 'vcr'
require 'webmock/rspec'
require 'barometer/support'

require_relative '../lib/barometer/weather_bug'

Dir['./spec/support/**/*.rb'].sort.each {|f| require f}

WEATHERBUG_CLIENT_ID = Barometer::Support::KeyFileParser.find(:weather_bug, :client_id) || 'weatherbug_id'
WEATHERBUG_CLIENT_SECRET = Barometer::Support::KeyFileParser.find(:weather_bug, :client_secret) || 'weatherbug_secret'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.default_cassette_options = { record: :none, serialize_with: :json }

  config.filter_sensitive_data('WEATHERBUG_CLIENT_ID') { WEATHERBUG_CLIENT_ID.to_s }
  config.filter_sensitive_data('WEATHERBUG_CLIENT_SECRET') { WEATHERBUG_CLIENT_SECRET.to_s }
  config.filter_sensitive_data('WEATHERBUG_ACCESS_CODE') do |interaction|
    if !defined?(WEATHERBUG_ACCESS_CODE) && interaction.request.uri =~ /thepulseapi.earthnetworks.com\/oauth20\/token/
      WEATHERBUG_ACCESS_CODE = JSON.parse(interaction.response.body)['OAuth20']['access_token']['token']
    end
  end
    config.filter_sensitive_data('WEATHERBUG_ACCESS_CODE') { defined?(WEATHERBUG_ACCESS_CODE) ? WEATHERBUG_ACCESS_CODE.to_s : 'this_should_not_match'  }

  config.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.include Barometer::Support::Matchers
  config.include Barometer::Support::Factory
end
