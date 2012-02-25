class BasicObject #:nodoc:
  instance_methods.each { |m| undef_method m unless m =~ /(^__|^nil\?$|^send$|instance_eval|proxy_|^object_id$)/ }
end unless defined?(BasicObject)

module PivotalTracker
  class Proxy < BasicObject

    def initialize(owner, target)
      @owner = owner
      @target = target
      @opts = {}
    end

    def all(options={})
      proxy_found(options)
    end

    def find(param, options={})
      return all(options) if param == :all
      return @target.find(param, @owner.id) if @target.respond_to?("find")
      return proxy_found(options).detect { |document| document.id == param }
    end

    def <<(*objects)
      objects.flatten.each do |object|
        if obj = object.create
          return obj
        else
          return object
        end
      end
    end

    def create(args = {})
      object = @target.new(args.merge({:owner => @owner}))
      if obj = object.create
        return obj
      else
        return object
      end
    end

    protected

      def proxy_found(options)
        if @found.nil? or @opts != options
          @opts = options
          @found = load_found()
        end
        @found
      end

    private

      def method_missing(method, *args, &block)
        @target.send(method, *args, &block)
      end

      def load_found()
        @target.all(@owner, @opts)
      end

  end
end
