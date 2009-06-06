# TODO make these conditional on to_param not existing...
class String
  def to_param
    self
  end

  def to_pivotal_filter
    self.inspect
  end
end

class Integer
  def to_param
    to_s
  end

  def to_pivotal_filter
    to_s.inspect
  end
end

class Hash
  def to_pivotal_filter
    collect do |key, value|
      %Q{#{key}:"#{value}"}
    end.join(' ')
  end
end

class NilClass
  def to_pivotal_filter
    ""
  end
end

class Array
  def to_pivotal_filter
    collect do |each|
      each.to_pivotal_filter
    end.join(' ')
  end
end
