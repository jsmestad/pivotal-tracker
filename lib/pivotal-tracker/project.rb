require 'happymapper'

class Project
  include HappyMapper
  element :id, Integer
  element :name, String
  element :iteration_length, Integer
  element :week_start_day, String
  element :point_scale, String
end
