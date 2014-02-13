module MrDarcy
  class Context

    class << self

      def role role_name, options={}, &block
        self.roles[role_name] = Role.new(role_name, options, &block)
      end

      def action action_name, &block
        define_method action_name do |*args|
          self.then(*args, &block)
        end
      end

      def roles
        @roles ||= {}
      end

    end

  end
end
