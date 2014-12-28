module MrDarcy
  module Promise
    module State
      # Represents the resolved state of a promise.
      class Resolved < Base
        def resolved?
          true
        end
      end
    end
  end
end
