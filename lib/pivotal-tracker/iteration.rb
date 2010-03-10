module PivotalTracker
  class Iteration
    include HappyMapper

    class << self
      def all(project, options={})
        params = PivotalTracker.encode_options(options.only(:limit, :offset))
        parse(Client.connection["/project/#{project.id}/iterations#{params}"].get)
      end
    end

    element :id, Integer
    element :number, Integer
    element :start, DateTime
    element :finish, DateTime

    has_many :stories, Story

  end
end
