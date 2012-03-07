class Object # :doc:

  # By default, deepfreeze is just freeze.
  def deepfreeze; freeze end

  alias :__deepfreeze__ :deepfreeze

end
