module MrDarcy
  module Promise
    class DSL

      def initialize promise
        @promise = promise
      end

      def resolve(value)
        promise.resolve value
      end

      def reject(exception)
        promise.reject exception
      end

      %w| unresolved? resolved? rejected? then fail result final |.map(&:to_sym).each do |method|
        define_method method do |*args|
          promise.public_send method, *args
        end
      end

      private

      attr_accessor :promise

    end
  end
end
