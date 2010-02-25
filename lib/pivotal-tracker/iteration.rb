class Iteration
  include HappyMapper

  class << self
    def all(project, options={})
      parse(Client.connection["/project/#{project.id}/iterations"].get)
    end
  end

  element :id, Integer
  element :number, Integer
  element :start, DateTime
  element :finish, DateTime
  # TODO: need to implement story building
  # has_many :stories, Story
end
