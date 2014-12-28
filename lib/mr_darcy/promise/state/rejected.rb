module MrDarcy
  module Promise
    module State
      # Represents the rejected state of a promise.
      class Rejected < Base
        def rejected?
          true
        end
      end
    end
  end
end
