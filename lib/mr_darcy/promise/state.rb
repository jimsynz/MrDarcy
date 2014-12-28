module MrDarcy
  module Promise
    # Implementation of the State Pattern for Promises.
    module State
      autoload :Base,       File.expand_path('../state/base', __FILE__)
      autoload :Unresolved, File.expand_path('../state/unresolved', __FILE__)
      autoload :Resolved,   File.expand_path('../state/resolved', __FILE__)
      autoload :Rejected,   File.expand_path('../state/rejected', __FILE__)

      module_function

      # Return an instance of the correct State class based on the state of
      # the passed in object.
      def state stateful
        case stateful.send :state
        when :unresolved
          Unresolved.new stateful
        when :resolved
          Resolved.new stateful
        when :rejected
          Rejected.new stateful
        else
          raise "Unknown state #{stateful.state}"
        end
      end
    end
  end
end
