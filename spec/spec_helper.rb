require 'rubygems'
require 'bundler'
Bundler.setup(:default)
require 'clearsale'
require 'vcr'
require 'savon'

HTTPI.log = false

Dir["./spec/support/**/*.rb"].each {|f| require f}

VCR.config do |c|
  c.cassette_library_dir     = File.expand_path('../../spec/fixtures/vcr_cassettes', __FILE__)
  c.stub_with :webmock
  c.default_cassette_options = { :record => :none }
  c.allow_http_connections_when_no_cassette = false
end

RSpec.configure do |config|
  config.mock_with :rspec
end

Clearsale::Config.log = false
