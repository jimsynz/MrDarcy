module MrDarcy
  module Promise
    module State
      autoload :Base,       File.expand_path('../state/base', __FILE__)
      autoload :Unresolved, File.expand_path('../state/unresolved', __FILE__)
      autoload :Resolved,   File.expand_path('../state/resolved', __FILE__)
      autoload :Rejected,   File.expand_path('../state/rejected', __FILE__)

      module_function

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
