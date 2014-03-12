module MrDarcy
  module Promise
    module State
      class Base
        attr_accessor :stateful

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
          raise "Can't resolve from #{get_state} state"
        end

        def reject
          raise "Cant reject from #{get_state} state"
        end

        private

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
