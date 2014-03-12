require 'stateflow'
Stateflow.persistence = :none

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
        puts "thenning to #{child_promise}"
        child_promise.resolve_block = block
        resolve_child_promise if resolved?
        child_promise.promise
      end

      def fail &block
        @child_promise ||= generate_child_promise
        puts "failing to #{child_promise}"
        child_promise.reject_block = block
        reject_child_promise if rejected?
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
          state.public_send method, *args
        end
      end

      def resolve value
        @value = value
        state.resolve
      end

      def reject exception
        @value = value
        state.reject
      end

      private

      attr_accessor :value, :child_promise


      def state
        @state ||= State.new(self)
      end

      def resolve_child_promise
        puts "resolving #{child_promise}"
        if child_promise
          puts "resolving child promise"
          if child_promise.unresolved?
            child_promise.parent_resolved(value)
          else
            raise "Deferred promise is not unresolved!"
          end
        end
      end

      def reject_child_promise
        puts "rejecting #{child_promise}"
        if child_promise
          puts "rejecting child promise"
          if child_promise.unresolved?
            child_promise.parent_rejected(value)
          else
            raise "Deferred promise is not unresolved!"
          end
        end
      end

      def schedule_promise
        raise "Subclasses must implement me"
      end

      def evaluate_promise
        begin
          yield DSL.new(self)
        rescue Exception => e
          self.value = e
          self.reject
        end
      end

      def generate_child_promise
        raise "Subclasses must implement me"
      end

    end
  end
end
