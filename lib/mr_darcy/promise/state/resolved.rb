module MrDarcy
  module Promise
    module State
      class Resolved < Base
        def resolved?
          true
        end
      end
    end
  end
end
