class Set

  # Implements a "deep" freeze and returns +self+.
  def deepfreeze
    each { |v| v.deepfreeze rescue nil }
    freeze
  end
  
end
