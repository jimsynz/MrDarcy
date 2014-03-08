module MrDarcy
  class PromiseDSL

    attr_accessor :promise

    def initialize(promise)
      self.promise = promise
    end

    def resolve(value)
      promise.value = value
      promise.resolve!
    end

    def reject(exception)
      promise.value = exception
      promise.reject!
    end

  end
end
