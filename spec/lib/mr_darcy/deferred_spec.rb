require 'spec_helper'

describe MrDarcy::Deferred do
  %w| promise last_promise resolved? rejected? unresolved? resolve reject
      final result raise then fail |.each do |method|
    it { should respond_to method }
  end
end
