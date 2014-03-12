module MrDarcy
  module Promise
    class Thread < Base

      def initialize *args
        @lock = Mutex.new
        @lock.lock
        super
      end

      def result
        wait_until_not_unresolved
        value
      end

      def final
        wait_until_not_unresolved
        self
      end

      def value=(x)
        semaphore.synchronize { super }
      end

      def resolve new_value
        semaphore.synchronize do
          value = super new_value
          condition.signal
          value
        end
      end

      def reject new_value
        semaphore.synchronize do
          value = super new_value
          condition.signal
          value
        end
      end

      private

      def schedule_promise &block
        ::Thread.new &block
      end

      def condition
        @condition ||= ConditionVariable.new
      end

      def wait_until_not_unresolved
        condition.wait @lock if unresolved?
      end

      def semaphore
        @semaphore ||= Mutex.new
      end

      def generate_child_promise
        ChildPromise.new driver: :thread
      end

    end
  end
end
