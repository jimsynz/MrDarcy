module MrDarcy
  class Context

    class << self
      def role role_name, options={}, &block
        self.roles[role_name] = Role.new(role_name, options, &block)
      end

      def action action_name, &block
        define_method action_name do |*args|
          self.then do |value|
            self.instance_exec(*args, &block)
          end
          self
        end
      end

      def roles
        @roles ||= {}
      end
    end

    def initialize role_players={}
      @driver   = role_players.delete(:driver) || MrDarcy.driver
      @deferred = Deferred.new(driver: driver) {}
      deferred.resolve nil

      roles = self.class.roles
      roles.each do |role_name, role|
        player = role_players[role_name]
        raise ArgumentError, "No role player for #{role_name} supplied" unless player

        role.pollute(player)

        self.singleton_class.send :define_method, role_name do
          player
        end
      end
    end

    def then &block
      deferred.then do |value|
        self.instance_exec(value, &block)
      end
      self
    end

    def fail &block
      deferred.fail do |value|
        self.instance_exec(value, &block)
      end
      self
    end

    %w| result rejected? resolved? unresolved? |.map(&:to_sym).each do |method|
      define_method method do
        deferred.public_send method
      end
    end

    def final
      deferred.final
      self
    end

    private

    attr_accessor :deferred, :driver

  end
end
