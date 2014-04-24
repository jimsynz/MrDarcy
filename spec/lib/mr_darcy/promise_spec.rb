require 'spec_helper'

shared_examples_for :threaded_promise do
  it { should be_a MrDarcy::Promise::Thread }
end

shared_examples_for :synchronous_promise do
  it { should be_a MrDarcy::Promise::Synchronous }
end

shared_examples_for :celluloid_promise do
  it { should be_a MrDarcy::Promise::Celluloid }
end

shared_examples_for :event_machine_promise do
  if RUBY_ENGINE == 'jruby'
    When 'on JRuby' do
      it 'raises an error' do
        expect { subject }.to raise_error
      end
    end
  else
    it { should be_a MrDarcy::Promise::EM }
  end
end

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
      it_should_behave_like :threaded_promise
    end

    When 'driver is :Thread' do
      let(:driver) { :Thread }
      it_should_behave_like :threaded_promise
    end

    When 'driver is :synchronous' do
      let(:driver) { :synchronous }
      it_should_behave_like :synchronous_promise
    end

    When 'driver is :Synchronous' do
      let(:driver) { :Synchronous }
      it_should_behave_like :synchronous_promise
    end

    When 'driver is :celluloid' do
      let(:driver) { :celluloid }
      it_should_behave_like :celluloid_promise
    end

    When 'driver is :Celluloid' do
      let(:driver) { :Celluloid }
      it_should_behave_like :celluloid_promise
    end

    When 'driver is :em' do
      let(:driver) { :em }
      it_should_behave_like :event_machine_promise
    end

    When 'driver is :EM' do
      let(:driver) { :EM }
      it_should_behave_like :event_machine_promise
    end

    When 'driver is :event_machine' do
      let(:driver) { :event_machine }
      it_should_behave_like :event_machine_promise
    end

    When 'driver is :eventmachine' do
      let(:driver) { :eventmachine }
      it_should_behave_like :event_machine_promise
    end

    When 'driver is :EventMachine' do
      let(:driver) { :EventMachine }
      it_should_behave_like :event_machine_promise
    end
  end
end
