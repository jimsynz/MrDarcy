require 'celluloid/autostart'

module MrDarcy
  module Promise
    class Celluloid < Base

      def initialize *args
        @waiting = false
        super
      end

      def resolve value
        super
        condition.signal if @waiting
      end

      def reject exception
        super
        condition.signal if @waiting
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
    end
  end
end
