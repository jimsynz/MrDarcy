module MrDarcy
  class PromiseDSL

    attr_accessor :promise

    def initialize(promise)
      self.promise = promise
    end

    def resolve(value)
      promise.resolve!
      promise.value = value
    end

    def reject(exception)
      promise.reject!
      promise.value = exception
    end

  end
end
