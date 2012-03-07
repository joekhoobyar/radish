class Array
    
  # Implements a "deep" freeze and returns +self+.
  def deepfreeze
    each { |v| v.deepfreeze rescue nil }
    freeze
  end
  
  # Creates a frozen array.
  def self.new_frozen(a)
    new(a).freeze
  end
  
  # Creates a deeply frozen array.
  def self.new_deepfrozen(a)
    new(a).deepfreeze
  end

end
