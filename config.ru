require "rubygems"
require "sinatra"
require "rack-environment"

require "./airbrake_to_pivotal"

use RackEnvironment if ENV['RACK_ENV'] == 'development'
run AirbrakeToPivotal.new
