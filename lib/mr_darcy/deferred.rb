module MrDarcy
  class Deferred

    attr_accessor :promise, :resolve_block, :reject_block

    %i| then fail resolved? rejected? unresolved? |.each do |method|
      define_method method do |*args|
        promise.public_send(method, *args)
      end
    end

    def initialize
      self.promise = Promise.new {}
    end

    def parent_resolved value
      parent_did :resolve, value
    end

    def parent_rejected exception
      parent_did :reject, exception
    end

    def parent_did event, value
      begin
        block = public_send("#{event}_block")
        if block
          value = block.call(value)
          if value.respond_to? :then
            value.then do |v|
              promise.value = v
              promise.resolve!
            end
          else
            promise.value = value
            promise.resolve!
          end
        else
          promise.value = value
          promise.public_send("#{event}!")
        end

      rescue Exception => e
        promise.value = e
        promise.reject!
      end
    end
  end
end
