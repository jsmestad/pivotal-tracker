class Story
  include HappyMapper
  element :id, Integer
  element :story_type, String
  element :url, String
  element :estimate, Integer
  element :current_state, String
  element :name, String
  element :requested_by, String
  element :owned_by, String
  element :created_at, DateTime
  element :accepted_at, DateTime
  element :labels, String
  

  def initialize(attributes = {})
    attributes.each do |key, value|
      send("#{key}=", value)
    end
  end

  def to_xml(options = {})
    builder = Builder::XmlMarkup.new(options)
    builder.story do |story|
      story.id   id.to_s   if id
      story.type type.to_s if type
      story.name name.to_s if name
    end
  end

  def to_param
    id.to_s
  end
end
