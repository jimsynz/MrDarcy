module MrDarcy
  module Promise
    module State
      class Unresolved < Base
        def unresolved?
          true
        end

        def resolve
          set_state :resolved
        end

        def reject
          set_state :rejected
        end
      end
    end
  end
end
