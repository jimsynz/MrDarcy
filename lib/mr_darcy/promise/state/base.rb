module MrDarcy
  module Promise
    module State
      # Abstract base class for all Promise states.
      class Base
        def initialize stateful
          self.stateful = stateful
        end

        def unresolved?
          false
        end

        def resolved?
          false
        end

        def rejected?
          false
        end

        def resolve
          raise RuntimeError, "Can't resolve from #{get_state} state"
        end

        def reject
          raise RuntimeError, "Cant reject from #{get_state} state"
        end

        private

        attr_reader :stateful

        def get_state
          stateful.send :state
        end

        def set_state state
          stateful.send :state=, state
        end
      end
    end
  end
end
