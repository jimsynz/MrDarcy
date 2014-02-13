module MrDarcy
  class Role
    attr_accessor :name, :options

    def initialize name, opts={}, &block
      self.name    = name
      self.options = opts
      @module = Module.new(&block)
    end

    def pollute player
      guard_against_false_players player

      @module.instance_methods.each do |method_name|
        implementation = @module.instance_method method_name
        player.define_singleton_method method_name, implementation
      end
    end

    def clean player
      @module.instance_methods.each do |method_name|
        player.singleton_class.send :remove_method, method_name if player.respond_to? method_name
      end
    end

    private

    def guard_against_false_players player
      options.each do |test_type, values|
        case test_type
        when :must_respond_to
          Array(values).each do |method_name|
            raise ArgumentError, "player must implement #{method_name}" unless player.respond_to? method_name
          end
        when :must_not_respond_to
          Array(values).each do |method_name|
            raise ArgumentError, "player must not implement #{method_name}" if player.respond_to? method_name
          end
        else
          raise ArgumentError, "unknown restriction #{test_type}"
        end
      end
    end
  end
end
