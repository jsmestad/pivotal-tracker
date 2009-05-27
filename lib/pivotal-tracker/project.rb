class Project
  include HappyMapper
  element :name, String
  element :iteration_length, String
  element :week_start_day, String
  element :point_scale, String
end
