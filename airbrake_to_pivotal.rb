require "sinatra/base"
require "./airbrake"
require "./pivotal"

class AirbrakeToPivotal < Sinatra::Base
  # def initialize
    # use RackEnvironment # if ENV['RACK_ENV'] == 'development'
    
    # raise "boom: #{ENV["AIRBRAKE_USERNAME"]}"

    # @airbrake = Airbrake.new(ENV["AIRBRAKE_USERNAME"], ENV["AIRBRAKE_AUTH_TOKEN"], ENV["AIRBRAKE_PROJECT_ID"])
    # @pivotal = Pivotal.new(ENV["AIRBRAKE_REQUESTOR"])
  # end
  
  use Rack::Auth::Basic do |username, password|
    username == ENV["HTTP_BASIC_USERNAME"] && password == ENV["HTTP_BASIC_PASSWORD"]
  end

  get "/:airbrake_id" do
    content_type "text/xml", :charset => "utf-8"
    @pt ||= Pivotal.new(ENV["AIRBRAKE_REQUESTOR"])
    @airbrake = Airbrake.new(ENV["AIRBRAKE_USERNAME"], ENV["AIRBRAKE_AUTH_TOKEN"], params[:airbrake_id])
    
    if @airbrake.bugs
      @pt.bugs_to_xml(@airbrake.bugs)
    else
      raise "No bugs; check your project ID"
    end
  end

end
