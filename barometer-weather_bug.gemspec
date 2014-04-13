# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require 'barometer/weather_bug/version'

Gem::Specification.new do |spec|
  spec.name = 'barometer-weather_bug'
  spec.version = Barometer::WeatherBug::VERSION
  spec.authors = ['Mark Gangl']
  spec.email = ['mark@attackcorp.com']
  spec.description = 'A barometer adapter for WeatherBug'
  spec.summary = spec.description
  spec.homepage = 'http://github.com/attack/barometer-weather_bug'
  spec.license = 'MIT'

  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 1.9.2'

  spec.files = `git ls-files`.split($/)
  spec.test_files = spec.files.grep(%r{^spec/})
  spec.require_paths = ['lib']

  spec.add_dependency 'barometer', '~> 0.9.5'

  spec.add_development_dependency 'bundler'
end
