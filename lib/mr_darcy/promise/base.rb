module MrDarcy
  module Promise
    class Base

      def initialize block
        state
        schedule_promise do
          evaluate_promise &block
        end
        did_initialize
      end

      def then &block
        ensure_child_promise
        child_promise.resolve_block = block
        resolve_or_reject_child_as_needed
        child_promise.promise
      end

      def fail &block
        ensure_child_promise
        child_promise.reject_block = block
        resolve_or_reject_child_as_needed
        child_promise.promise
      end

      def result
        Kernel::raise "Subclasses must implement me"
      end

      def final
        Kernel::raise "Subclasses must implement me"
      end

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

      %w| resolved? unresolved? rejected? |.map(&:to_sym).each do |method|
        define_method method do |*args|
          state_machine.public_send(method, *args)
        end
      end

      def resolve value
        do_resolve value
        self
      end

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
          dsl = DSL.new(self)
          dsl.instance_exec dsl, &block
          # block.call DSL.new(self)
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
