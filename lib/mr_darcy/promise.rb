require 'thread'
require 'stateflow'
Stateflow.persistence = :none

module MrDarcy
  class Promise
    include Stateflow

    attr_accessor :value, :next_promise

    stateflow do
      initial :unresolved

      state :unresolved

      state :resolved do
        enter :resolve_next_promise
      end

      state :rejected do
        enter :reject_next_promise
      end

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

    def then &block
      self.next_promise ||= Deferred.new
      next_promise.resolve_block = block
      next_promise.parent_resolved(value) if resolved?
      next_promise.promise
    end

    def fail &block
      self.next_promise ||= Deferred.new
      next_promise.reject_block = block
      next_promise.parent_rejected(value) if rejected?
      next_promise.promise
    end

    private

    def resolve_next_promise
      Thread.new{next_promise && next_promise.parent_resolved(value)}
    end

    def reject_next_promise
      Thread.new{next_promise && next_promise.parent_rejected(value)}
    end

    def evaluate_promise(block)
      MrDarcy::PromiseDSL.new(self).instance_exec(&block)
    end

  end
end
