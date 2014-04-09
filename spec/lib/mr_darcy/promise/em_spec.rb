require 'spec_helper'

describe MrDarcy::Promise::EM do
  describe '#initialize' do
    describe 'JRuby warning' do
      subject { -> { MrDarcy::Promise::EM.new proc {} } }

      When 'running on jruby' do
        before { stub_const 'RUBY_ENGINE', 'jruby' }

        it { should raise_error }
      end

      Otherwise do
        it { should_not raise_error }
      end unless RUBY_ENGINE == 'jruby'
    end

  end
end
