# TODO make these conditional on to_param not existing...
class String
  def to_param
    self
  end
end

class Integer
  def to_param
    to_s
  end
end
