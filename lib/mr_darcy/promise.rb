require 'stateflow'
Stateflow.persistence = :none

module MrDarcy
  class Promise
    include Stateflow

    attr_accessor :value

    stateflow do
      initial :unresolved
      state :unresolved, :resolved, :rejected

      event :resolve do
        transitions from: :unresolved, to: :resolved
      end

      event :reject do
        transitions from: :unresolved, to: :rejected
      end
    end

    def self.new(&block)
      super(block)
    end

    def initialize(block)
      MrDarcy::PromiseDSL.new(self).instance_exec(&block)
    end

  end
end
