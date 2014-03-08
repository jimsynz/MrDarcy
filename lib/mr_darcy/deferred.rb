module MrDarcy
  class Deferred

    attr_accessor :promise, :resolve_block, :reject_block

    %i| resolved? rejected? unresolved? |.each do |method|
      define_method method do |*args|
        promise.public_send(method, *args)
      end
    end

    def initialize resolve: nil, reject: nil
      self.resolve_block = resolve
      self.reject_block  = reject
      self.promise = Promise.new {}
    end

    def parent_resolved _value
      begin
        promise.value = resolve_block.call(_value)
        promise.resolve!
      # rescue Exception => e
      #   promise.value = e
      #   promise.reject!
      end
    end

    def parent_rejected exception
      begin
        if reject_block
          promise.value = reject_block.call(exception)
          promise.resolve!
        else
          promise.value = exception
          promise.reject!
        end
      # rescue Exception => e
      #   promise.value = e
      #   promise.reject!
      end
    end
  end
end
