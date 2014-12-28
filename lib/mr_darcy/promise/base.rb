require 'forwardable'

module MrDarcy
  module Promise

    # An abstract superclass for all promise implementations.
    class Base
      extend Forwardable

      def_delegators :state_machine, :resolved?, :unresolved?, :rejected?

      # Create a new promise and schedule it for execution.
      def initialize block
        state
        schedule_promise do
          evaluate_promise &block
        end
        did_initialize
      end

      # Create a new promise that resolves and calls the supplied
      # block when this promise is resolved.
      def then &block
        ensure_child_promise
        child_promise.resolve_block = block
        resolve_or_reject_child_as_needed
        child_promise.promise
      end

      # Create a new promise that rejects and calls the supplied
      # block when this promise is rejected.
      def fail &block
        ensure_child_promise
        child_promise.reject_block = block
        resolve_or_reject_child_as_needed
        child_promise.promise
      end

      # Wait until the promise is resolved or rejected and return it's
      # result value.
      def result
        Kernel::raise "Subclasses must implement me"
      end

      # Wait until the promise is resolved or rejected and return self.
      def final
        Kernel::raise "Subclasses must implement me"
      end

      # Wait until the promise is resolver or rejected, and if rejected
      # raise the error value in this context.
      def raise
        r = result
        if rejected?
          if r.is_a? Exception
            super r
          else
            super RuntimeError, r
          end
        end
      end

      # Resolve this promise with the provided value.
      def resolve value
        do_resolve value
        self
      end

      # Reject this promise with the provided error/value.
      def reject exception
        do_reject exception
        self
      end

      private

      attr_accessor :value, :state

      def do_resolve value
        will_resolve value
        set_value_to value
        state_machine_resolve
        resolve_child_promise
        did_resolve value
      end

      def do_reject exception
        will_reject exception
        set_value_to exception
        state_machine_reject
        reject_child_promise
        did_reject exception
      end

      def will_resolve value; end
      def will_reject value; end
      def did_resolve value; end
      def did_reject value; end
      def did_initialize; end

      def state
        @state ||= :unresolved
      end

      def set_value_to value
        @value = value
      end

      def state_machine_resolve
        state_machine.resolve
      end

      def state_machine_reject
        state_machine.reject
      end

      def state_machine
        State.state(self)
      end

      def has_child_promise?
        !!child_promise
      end

      def resolve_child_promise
        child_promise.parent_resolved(value) if has_child_promise?
      end

      def reject_child_promise
        child_promise.parent_rejected(value) if has_child_promise?
      end

      def resolve_or_reject_child_as_needed
        resolve_child_promise if resolved?
        reject_child_promise  if rejected?
      end

      def schedule_promise
        Kernel::raise "Subclasses must implement me"
      end

      def evaluate_promise &block
        begin
          block.call DSL.new(self)
        rescue Exception => e
          reject e
        end
      end

      def generate_child_promise
        Kernel::raise "Subclasses must implement me"
      end

      def ensure_child_promise
        @child_promise ||= generate_child_promise
      end

      def child_promise
        @child_promise
      end

    end
  end
end
