module MrDarcy
  class Context

    attr_accessor :promise

    def initialize role_players={}
      self.promise = Promise.new {}
      promise.resolve!

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
      this = self
      self.promise.then do
        MrDarcy::Promise.new do
          resolve this.instance_exec(&block)
        end
      end
      self
    end

    def fail &block
      this = self
      self.promise.fail do
        MrDarcy::Promise.new do
          resolve this.instance_exec(&block)
        end
      end
      self
    end

    class << self

      def role role_name, options={}, &block
        self.roles[role_name] = Role.new(role_name, options, &block)
      end

      def action action_name, &block
        define_method action_name do |*args|
          this = self
          self.promise.then do
            MrDarcy::Promise.new do
              resolve this.instance_exec(*args, &block)
            end
          end
          self
        end
      end

      def roles
        @roles ||= {}
      end

    end

  end
end
