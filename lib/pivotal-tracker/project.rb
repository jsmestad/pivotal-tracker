module PivotalTracker
  class Project
    include HappyMapper

    class << self
      def all
        @found = parse(Client.connection['/projects'].get)
      end

      def find(id)
        if @found
          @found.detect { |document| document.id == id }
        else
          parse(Client.connection["/projects/#{id}"].get)
        end
      end
    end

    element :id, Integer
    element :name, String
    element :account, String
    element :week_start_day, String
    element :point_scale, String
    element :labels, String
    element :velocity_scheme, String
    element :iteration_length, Integer
    element :initial_velocity, Integer
    element :current_velocity, Integer
    element :last_activity_at, DateTime
    element :use_https, Boolean
    element :first_iteration_start_time, DateTime
    element :current_iteration_number, Integer

    def initialize(attributes={})
      update_attributes(attributes)
    end

    def create
      response = Client.connection["/projects"].post(self.to_xml, :content_type => 'application/xml')
      project = Project.parse(response)
      return project
    end

    def activities
      @activities ||= Proxy.new(self, Activity)
    end

    def iterations
      @iterations ||= Proxy.new(self, Iteration)
    end

    def stories
      @stories ||= Proxy.new(self, Story)
    end

    def memberships
      @memberships ||= Proxy.new(self, Membership)
    end

    def iteration(group)
      case group.to_sym
      when :done then Iteration.done(self)
      when :current then Iteration.current(self)
      when :backlog then Iteration.backlog(self)
      when :current_backlog then Iteration.current_backlog(self)
      else
        raise ArgumentError, "Invalid group. Use :done, :current, :backlog or :current_backlog instead."
      end
    end

    protected

      def to_xml
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.project {
            xml.name "#{name}"
            xml.iteration_length.integer "#{iteration_length}" unless iteration_length.nil?
            xml.point_scale "#{point_scale}" unless point_scale.nil?
          }
        end
        return builder.to_xml
      end

      def update_attributes(attrs)
        attrs.each do |key, value|
          self.send("#{key}=", value.is_a?(Array) ? value.join(',') : value )
        end
      end

  end
  class Project
    include Validation
  end
end
