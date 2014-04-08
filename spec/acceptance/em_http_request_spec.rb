require 'spec_helper'
require 'eventmachine'
require 'em-http-request'

describe "Wrapping em-http-request" do
  let(:promise) do
    MrDarcy::Promise.new driver: :em do |p|
      http = EM::HttpRequest.new('http://camp.ruby.org.nz/').get
      http.errback do
        p.reject http.error
      end
      http.callback do
        p.resolve http.response
      end
    end
  end

  subject { promise }

  it_should_behave_like 'a resolved promise'
  its(:result) { should match /Rails Camp NZ/i }
end
