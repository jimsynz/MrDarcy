require 'thread'

module MrDarcy
  module Drivers
    module Thread
      module_function

      def dispatch(&block)
        @threads ||= []
        @threads << ::Thread.new(&block)
      end

      def wait
        @threads ||= []
        @threads.each do |thread|
          thread.join unless Thread.current == thread
        end
      end
    end
  end
end
