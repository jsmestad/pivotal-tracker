class Membership
  include HappyMapper
  element :id, Integer
  element :role, String
  has_one :person, Person
end
