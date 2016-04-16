module PivotalTracker
  class Membership
    include HappyMapper

    class << self
      def all(project, options={})
        memberships = parse(Client.connection["/projects/#{project.id}/memberships"].get)
        memberships.each { |m| m.project_id = project.id }
        return memberships
      end

      def find(param, project_id)
        begin
          membership = parse(Client.connection["/projects/#{project_id}/memberships/#{param}"].get)
          membership.project_id = project_id
        rescue RestClient::ExceptionWithResponse
          membership = nil
        end
        return membership
      end
    end

    element :id, Integer
    element :role, String
    element :project_id, Integer

    # Flattened Attributes from <person>...</person>
    element :name, String, :deep => true
    element :email, String, :deep => true
    element :initials, String, :deep => true

    def initialize(attributes={})
      if attributes[:owner]
        self.project_id = attributes.delete(:owner).id
      end
      update_attributes(attributes)
    end

    def create
      return self if project_id.nil?
      response = Client.connection["/projects/#{project_id}/memberships"].post(self.to_xml, :content_type => 'application/xml')
      new_membership = Membership.parse(response)
      new_membership.project_id = project_id
      return new_membership
    end

    def update(attrs={})
      update_attributes(attrs)
      response = Client.connection["/projects/#{project_id}/memberships/#{id}"].put(self.to_xml, :content_type => 'application/xml')
      return Membership.parse(response)
    end

    def delete
      Client.connection["/projects/#{project_id}/memberships/#{id}"].delete
    end

    protected

    def to_xml
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.membership {
          xml.role "#{role}"
          xml.person {
            xml.email "#{email}"
            xml.initials "#{initials}"
            xml.name "#{name}"
          }
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

  class Membership
    include Validation
  end
end
