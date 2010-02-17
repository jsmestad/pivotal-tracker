class BasicObject #:nodoc:
  instance_methods.each { |m| undef_method m unless m =~ /(^__|^nil\?$|^send$|instance_eval|proxy_|^object_id$)/ }
end unless defined?(BasicObject)

module PivotalTracker
  class Proxy < BasicObject

    def initialize(owner, target)
      @owner = owner
      @target = target
    end

    def all
      proxy_found
    end

    def find(param)
      return all if param == :all
      return proxy_found.detect { |document| document.id == param }
    end

    def build(args={})
      object = @target.new(args)
      found << object
      object
    end

    def <<(*objects)
      objects.flatten.each do |object|
        @found << object
      end
    end

    protected

      def proxy_found
        @found || load_found
      end

    private

      def method_missing(method, *args, &block)
        @target.send(method, *args, &block)
      end

      def load_found
        @target.all(@owner)
      end

  end
end
