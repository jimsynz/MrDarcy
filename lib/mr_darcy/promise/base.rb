module MrDarcy
  module Promise
    class Base

      def initialize block
        state
        schedule_promise do
          evaluate_promise &block
        end
      end

      def then &block
        @child_promise ||= generate_child_promise
        child_promise.resolve_block = block
        resolve_child_promise if resolved?
        reject_child_promise  if rejected?
        child_promise.promise
      end

      def fail &block
        @child_promise ||= generate_child_promise
        child_promise.reject_block = block
        resolve_child_promise if resolved?
        reject_child_promise  if rejected?
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
        Kernel::raise r if rejected?
      end

      %i| resolved? unresolved? rejected? |.each do |method|
        define_method method do |*args|
          state_machine.public_send(method, *args)
        end
      end

      def resolve value
        set_value_to value
        state_machine_resolve
        resolve_child_promise
      end

      def reject exception
        set_value_to exception
        state_machine_reject
        reject_child_promise
      end

      private

      attr_accessor :value, :child_promise, :state

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
        schedule_promise do
          child_promise.parent_resolved(value) if has_child_promise?
        end
      end

      def reject_child_promise
        schedule_promise do
          child_promise.parent_rejected(value) if has_child_promise?
        end
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

    end
  end
end
