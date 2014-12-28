require 'thread'

# Backend abstraction for scheduling blocks into threads.

module MrDarcy
  module Drivers
    module Thread
      module_function

      # Create a new thread with the supplied block and store it
      # on the thread stack.
      def dispatch(&block)
        @threads ||= []
        @threads << ::Thread.new(&block)
      end

      # Iterate through all threads in the thread stack and wait
      # until they are complete.
      def wait
        @threads ||= []
        @threads.each do |thread|
          thread.join unless ::Thread.current == thread
        end
        yield
      end
    end
  end
end
