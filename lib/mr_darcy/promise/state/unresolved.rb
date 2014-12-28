module MrDarcy
  module Promise
    module State
      # Represents the unresolved state of a promise.
      class Unresolved < Base
        def unresolved?
          true
        end

        # Transition into resolved state.
        def resolve
          set_state :resolved
        end

        # Transition into rejected state.
        def reject
          set_state :rejected
        end
      end
    end
  end
end
