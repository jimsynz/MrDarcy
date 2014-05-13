require 'spec_helper'

describe MrDarcy::Promise::Collection do
  MrDarcy.all_drivers.each do |driver|
    describe "with driver #{driver}" do
      next if driver == :synchronous

      let(:first_promise)  { MrDarcy.promise(driver: driver) { |p| p.resolve 1 } }
      let(:second_promise) { MrDarcy.promise(driver: driver) { |p| p.resolve 2 } }
      let(:third_promise)  { MrDarcy.promise(driver: driver) { |p| p.resolve 3 } }
      let(:three_promises) { [ first_promise, second_promise, third_promise ] }
      let(:collection) { described_class.new three_promises, driver: driver }
      subject { collection }

      its(:final) { should be_an Enumerable }
      its(:final) { should respond_to :each }
      its(:final) { should respond_to :push }
      its(:final) { should respond_to :<< }
      its(:final) { should respond_to :size }
      its(:final) { should respond_to :promises }
      its(:final) { should respond_to :raise }

      When 'all the promises resolve' do
        its(:result) { should eq [1,2,3] }
        its(:final)  { should be_resolved }
      end

      When 'any of the promises reject' do
        let(:second_promise) { MrDarcy.promise(driver: driver) { |p| p.reject 2 } }
        its(:final)  { should be_rejected }
        its(:result) { should eq 2 }
      end
    end
  end
end
