require 'spec_helper'
require 'eventmachine'
require 'em-http-request'

describe "Wrapping em-http-request" do
  let(:promise) do
    MrDarcy::Promise.new driver: :thread do |p|
      EM.run do
        http = EM::HttpRequest.new('http://camp.ruby.org.nz/').get
        http.errback do
          p.reject http.error
          EM.stop
        end
        http.callback do
          p.resolve http.response
          EM.stop
        end
      end
    end
  end

  subject { promise }

  its(:result) { should match /Rails Camp NZ/i }
end
