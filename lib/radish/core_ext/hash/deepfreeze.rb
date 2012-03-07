class Hash
  
  # Implements a "deep" freeze and returns +self+.
  def deepfreeze
    values.each { |v| v.deepfreeze rescue nil }
    default.deepfreeze rescue nil
    freeze
  end

end
