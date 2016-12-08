class Era
  ERAS = %w{Medieval Renaissance Baroque Classical Romantic Modernist}

  def self.all
    ERAS.map { |era| new(era) }
  end

  def self.from_string(string)
    return self.with_name('Modernist') if string.scan('20th-century').present?
    self.all.detect { |era| string.scan(/#{era.name}/i).present? }
  end

  def self.with_name(name)
    self.all.detect { |era| era.name == name }
  end

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def color
    name.first(3)
  end
end
