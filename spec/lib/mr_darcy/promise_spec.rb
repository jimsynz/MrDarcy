require 'spec_helper'

describe MrDarcy::Promise do
  describe '.new' do
    let(:driver) { nil }
    subject { MrDarcy::Promise.new(driver: driver) {} }

    When 'no driver is provided' do
      subject { MrDarcy::Promise.new {} }

      it 'uses the default' do
        expect(MrDarcy).to receive(:driver).and_return(:thread)
        expect(subject).to be_a MrDarcy::Promise::Thread
      end
    end

    When 'driver is :thread' do
      let(:driver) { :thread }
      it { should be_a MrDarcy::Promise::Thread }
    end

    When 'driver is :Thread' do
      let(:driver) { :Thread }
      it { should be_a MrDarcy::Promise::Thread }
    end

    When 'driver is :synchronous' do
      let(:driver) { :synchronous }
      it { should be_a MrDarcy::Promise::Synchronous }
    end

    When 'driver is :Synchronous' do
      let(:driver) { :Synchronous }
      it { should be_a MrDarcy::Promise::Synchronous }
    end

    When 'driver is :celluloid' do
      let(:driver) { :celluloid }
      it { should be_a MrDarcy::Promise::Celluloid }
    end

    When 'driver is :Celluloid' do
      let(:driver) { :Celluloid }
      it { should be_a MrDarcy::Promise::Celluloid }
    end

    When 'driver is :em' do
      let(:driver) { :em }
      it { should be_a MrDarcy::Promise::EM }
    end

    When 'driver is :EM' do
      let(:driver) { :EM }
      it { should be_a MrDarcy::Promise::EM }
    end

    When 'driver is :event_machine' do
      let(:driver) { :event_machine }
      it { should be_a MrDarcy::Promise::EM }
    end

    When 'driver is :eventmachine' do
      let(:driver) { :eventmachine }
      it { should be_a MrDarcy::Promise::EM }
    end

    When 'driver is :EventMachine' do
      let(:driver) { :EventMachine }
      it { should be_a MrDarcy::Promise::EM }
    end
  end
end
