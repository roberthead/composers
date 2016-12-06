class Era
  ERAS = %w{Medieval Renaissance Baroque Classical Romantic Modernist}

  def self.all
    ERAS.map { |era| new(era) }
  end

  def self.from_string(string)
    self.all.detect { |era| string.scan(/#{era.name}/i).present? }
  end

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def color
    name.first(3)
  end
end
