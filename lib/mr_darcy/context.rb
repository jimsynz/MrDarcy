require 'forwardable'

# This class defines the abstract ability to create DCI roles in MrDarcy.
# Start by subclassing and adding some roles and actions and away you go.
module MrDarcy
  class Context
    extend Forwardable

    def_delegators :deferred, :result, :rejected?, :resolved?, :unresolved?

    class << self
      # Defines a role to be mixed into the roll-player
      # when this context is initialized.
      #
      # See MrDarcy::Role#initialize for argument definitions.
      def role role_name, options={}, &block
        self.roles[role_name] = Role.new(role_name, options, &block)
      end

      # Defines an action that can be performed in this
      # context.
      #
      #  * action_name: essentially the name of the method defined in this class.
      #
      # Takes a block with which to define the action.
      def action action_name, &block
        define_method action_name do |*args|
          self.then do |value|
            self.instance_exec(*args, &block)
          end
          self
        end
      end

      # A list of available roles in this context.
      def roles
        @roles ||= {}
      end
    end

    # Create an instance of the context.  You must pass in role-players
    # for all roles defined in this context using a single hash argument
    # of role names (as symbols) to objects.
    #
    # eg:
    #
    #   BankTransfer.new money_source: account1, money_destination: account2
    def initialize role_players={}
      @driver   = role_players.delete(:driver) || MrDarcy.driver
      @deferred = Deferred.new(driver: driver) {}
      deferred.resolve nil

      roles = self.class.roles
      roles.each do |role_name, role|
        player = role_players[role_name]
        Kernel::raise ArgumentError, "No role player for #{role_name} supplied" unless player

        role.pollute(player)

        self.singleton_class.send :define_method, role_name do
          player
        end
      end
    end

    # See MrDarcy::Promise::Base#then
    def then &block
      deferred.then do |value|
        self.instance_exec(value, &block)
      end
      self
    end

    # See MrDarcy::Promise::Base#fail
    def fail &block
      deferred.fail do |value|
        self.instance_exec(value, &block)
      end
      self
    end

    # See MrDarcy::Promise::Base#final
    def final
      deferred.final
      self
    end

    private

    attr_accessor :deferred, :driver

  end
end
