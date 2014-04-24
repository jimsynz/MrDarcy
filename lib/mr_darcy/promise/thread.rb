require 'thread'
require 'fiber'

module MrDarcy
  module Promise
    class Thread < Base

      def initialize *args
        semaphore
        semaphore.synchronize { @complete = false }
        super
      end

      def result
        wait_if_unresolved
        value
      end

      def final
        wait_if_unresolved
        self
      end

      private

      def schedule_promise &block
        ::Thread.new &block
      end

      def did_resolve value
        complete!
      end

      def did_reject value
        complete!
      end

      def resolve_or_reject_child_as_needed
        ::Thread.new do
          super
        end
      end

      def wait_if_unresolved
        ::Thread.pass until complete?
      end

      def generate_child_promise
        ChildPromise.new driver: :thread
      end

      def complete?
        semaphore.synchronize { @complete }
      end

      def complete!
        semaphore.synchronize { @complete = true }
      end

      def semaphore
        @semaphore ||= Mutex.new
      end

      def set_value_to value
        semaphore.synchronize { super }
      end

      def state_machine
        semaphore.synchronize { super }
      end

      def child_promise
        semaphore.synchronize { super }
      end

      def value
        semaphore.synchronize { super }
      end

    end
  end
end
