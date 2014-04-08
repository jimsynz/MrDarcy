require 'spec_helper'
require 'open-uri'

describe "Wrapping OpenURI" do
  MrDarcy.all_drivers.each do |driver|
    describe "driver #{driver}" do
      let(:promise) do
        MrDarcy::Promise.new driver: driver do |p|
          open('http://camp.ruby.org.nz') do |f|
            p.resolve f.read
          end
        end
      end

      subject { promise }

      it_should_behave_like 'a resolved promise'
      its(:result) { should match /Rails Camp NZ/i }
    end
  end
end
