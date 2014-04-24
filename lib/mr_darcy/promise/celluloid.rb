require 'celluloid/autostart'

module MrDarcy
  module Promise
    class Celluloid < Base

      def initialize *args
        @waiting = false
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

      private

      def notify_waiting
        condition.signal if @waiting
      end

      def schedule_promise &block
        ::Celluloid::Future.new &block
      end

      def condition
        @condition ||= ::Celluloid::Condition.new
      end

      def wait_until_not_unresolved
        @waiting = true
        condition.wait if unresolved?
      end

      def generate_child_promise
        ChildPromise.new driver: :thread
      end

      def state_machine_resolve
        schedule_promise do
          super
        end
      end

      def state_machine_reject
        schedule_promise do
          super
        end
      end
    end
  end
end
