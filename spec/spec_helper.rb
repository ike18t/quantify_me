require File.dirname(__FILE__) + "/../app.rb"
require 'sinatra'
require 'rack/test'
require 'rspec'
require 'pry'
require_relative '../app'

set :environment, :test

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

def app
  QuantifyMeApp.new
end
