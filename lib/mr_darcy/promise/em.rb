require 'eventmachine'

module MrDarcy
  module Promise
    class EM < Thread

      def initialize *args
        ::Thread.new { EventMachine.run } unless EventMachine.reactor_running?
        ::Thread.pass until EventMachine.reactor_running?
        super
      end

      private

      def schedule_promise &block
        EventMachine.defer block
      end

      def generate_child_promise
        ChildPromise.new driver: :em
      end

    end
  end
end
