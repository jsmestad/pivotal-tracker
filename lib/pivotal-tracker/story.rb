class Story
  include HappyMapper
  element :id, Integer
  element :story_type, String
  element :url, String
  element :estimate, Integer
  # possible states: unscheduled, unstarted, started, finished, accepted, rejected
  element :current_state, String
  element :name, String
  element :requested_by, String
  element :owned_by, String
  element :created_at, DateTime
  element :accepted_at, DateTime
  element :labels, String
  has_one :iteration, Iteration

  def initialize(attributes = {})
    attributes.each do |key, value|
      send("#{key}=", value)
    end
  end

  def to_xml(options = {})
    builder = Builder::XmlMarkup.new(options)
    builder.story do |story|
      Story.elements.each do |element_type|
        element = send(element_type.name)
        eval("story.#{element_type.name}('#{element.to_s}')") if element
      end
    end
  end

  def to_param
    id.to_s
  end
end
