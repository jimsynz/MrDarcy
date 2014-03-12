module MrDarcy
  module Promise
    class Base
      def initialize(block)
        state
        schedule_promise do
          evaluate_promise(&block)
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
        raise "Subclasses must implement me"
      end

      def final
        raise "Subclasses must implement me"
      end

      def raise
        r = result
        raise r if rejected?
      end

      %i| resolved? unresolved? rejected? |.each do |method|
        define_method method do |*args|
          state_machine.public_send(method, *args)
        end
      end

      def resolve value
        @value = value
        state_machine.resolve
        resolve_child_promise
      end

      def reject exception
        @value = exception
        state_machine.reject
        reject_child_promise
      end

      private

      attr_accessor :value, :child_promise, :state

      def state
        @state ||= :unresolved
      end

      def state_machine
        State.state(self)
      end

      def has_child_promise?
        !!child_promise
      end

      def resolve_child_promise
        if has_child_promise?
          if child_promise.unresolved?
            schedule_promise do
              child_promise.parent_resolved(value)
            end
          else
            raise "Deferred promise is not unresolved!"
          end
        end
      end

      def reject_child_promise
        if child_promise
          if child_promise.unresolved?
            schedule_promise do
              child_promise.parent_rejected(value)
            end
          else
            raise "Deferred promise is not unresolved!"
          end
        end
      end

      def schedule_promise
        raise "Subclasses must implement me"
      end

      def evaluate_promise &block
        begin
          block.call DSL.new(self)
        rescue Exception => e
          self.reject e
        end
      end

      def generate_child_promise
        raise "Subclasses must implement me"
      end

    end
  end
end
