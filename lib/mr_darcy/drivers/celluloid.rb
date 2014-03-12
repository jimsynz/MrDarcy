require 'celluloid/autostart'

module MrDarcy
  module Drivers
    module Celluloid
      module_function

      def dispatch(&block)
        futures << ::Celluloid::Future.new(&block)
      end

      def wait
        futures.each do |future|
          future.value
        end
      end

      def futures
        @futures ||= []
      end
    end
  end
end
