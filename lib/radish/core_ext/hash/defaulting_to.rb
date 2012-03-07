class Hash
  
  # Sets the default value and returns +self+.
  def defaulting_to(d)
    self.default = d
    self
  end
  
  # Create a hash, along with a default value.
  def self.new_with_default(d, h)
    new(h).defaulting_to(d)
  end
  
  # Creates a frozen hash, along with a default value.
  def self.new_frozen_with_default(d, h)
    new(h).defaulting_to(d).freeze
  end
  
  # Creates a deeply frozen hash, along with a default value.
  def self.new_deepfrozen_with_default(d, h)
    new(h).defaulting_to(d).deepfreeze
  end
  
end
