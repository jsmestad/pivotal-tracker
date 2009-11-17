class Iteration
  include HappyMapper
  element :id, Integer
  element :number, Integer
  element :start, DateTime
  element :finish, DateTime
  has_many :stories, Story
end
