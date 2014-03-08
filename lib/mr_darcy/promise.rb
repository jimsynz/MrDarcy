require 'pry-byebug'
require 'stateflow'
Stateflow.persistence = :none

module MrDarcy
  class Promise
    include Stateflow

    attr_accessor :value, :deferred_promise

    stateflow do
      initial :unresolved

      state :unresolved

      state :resolved do
        enter :resolve_deferred_promise
      end

      state :rejected do
        enter :reject_deferred_promise
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
      begin
        evaluate_promise(block)
      rescue Exception => e
        puts "Exception #{e.inspect}"
        self.value = e
        self.reject!
      end
    end

    def then &block
      self.deferred_promise = Deferred.new
      deferred_promise.resolve_block = block
      deferred_promise.parent_resolved(value) if resolved?
      deferred_promise.promise
    end

    def fail &block
      self.deferred_promise = Deferred.new
      deferred_promise.reject_block = block
      deferred_promise.parent_rejected(value) if rejected?
      deferred_promise.promise
    end

    def result
      value
    end

    private

    def resolve_deferred_promise
      deferred_promise && deferred_promise.parent_resolved(value)
    end

    def reject_deferred_promise
      deferred_promise && deferred_promise.parent_rejected(value)
    end

    def evaluate_promise(block)
      dsl = MrDarcy::PromiseDSL.new(self)
      dsl.instance_exec(&block)
    end

  end
end
