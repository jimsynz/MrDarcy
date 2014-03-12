module MrDarcy
  module Promise
    module State
      class Rejected < Base
        def rejected?
          true
        end
      end
    end
  end
end
