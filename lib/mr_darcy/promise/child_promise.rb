module MrDarcy
  module Promise
    class ChildPromise

      attr_accessor :resolve_block, :reject_block, :promise

      def initialize opts={}
        self.promise = MrDarcy.promise(opts) {}
      end

      def parent_resolved value
        begin
          return resolve_with value unless handles_resolve?

          new_value = result_for :resolve, value
          return defer_resolution_via new_value if thenable? new_value
          resolve_with new_value
        rescue Exception => e
          reject_with e
        end
      end

      def parent_rejected value
        begin
          return reject_with value unless handles_reject?

          new_value = result_for :reject, value
          return defer_resolution_via new_value if thenable? new_value
          resolve_with new_value
        rescue Exception => e
          reject_with e
        end
      end

      private

      def result_for which, value
        block = public_send("#{which}_block")
        if block
          block.call value
        else
          value
        end
      end

      def handles_reject?
        !!reject_block
      end

      def handles_resolve?
        !!resolve_block
      end

      def thenable? object
        object.respond_to?(:then) && object.respond_to?(:fail)
      end

      def defer_resolution_via new_promise
        new_promise.then do |value|
          resolve_with value
          value
        end
        new_promise.fail do |exception|
          reject_with exception
          exception
        end
      end

      def resolve_with value
        promise.resolve value
      end

      def reject_with exception
        promise.reject exception
      end
    end
  end
end
