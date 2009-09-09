=begin
  <?xml version="1.0" encoding="UTF-8"?>
  <task>
    <id type="integer">TASK_ID</id>
    <description>find shields</description>
    <position>1</position>
    <complete>false</complete>
    <created_at type="datetime">2008/12/10 00:00:00 UTC</created_at>
  </task>
=end
class Task
  include HappyMapper
  element :id, Integer
  element :description, String
  element :position, Integer
  element :complete, Boolean
  element :created_at, DateTime

  def initialize(attributes = {})
    attributes.each do |key, value|
      send("#{key}=", value)
    end
  end

  def to_xml(options = {})
    builder = Builder::XmlMarkup.new(options)
    builder.task do |story|
      Task.elements.each do |element_type|
        element = send(element_type.name)
        eval("story.#{element_type.name}(\"#{element.to_s.gsub("\"", "\\\"")}\")") if element
      end
    end
  end

  def to_param
    id.to_s
  end
end
