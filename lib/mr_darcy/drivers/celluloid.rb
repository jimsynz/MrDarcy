require 'celluloid/autostart'

# The backend abstracting for scheduling blocks asynchronously
# with Celluloid.

module MrDarcy
  module Drivers
    module Celluloid
      module_function

      # Create a new future, and add it to the future stack.
      def dispatch(&block)
        futures << ::Celluloid::Future.new(&block)
      end

      # Iterate the future stack and wait for each to resolve.
      def wait
        futures.each do |future|
          future.value
        end
      end

      # Returns the future stack.
      def futures
        @futures ||= []
      end
    end
  end
end
