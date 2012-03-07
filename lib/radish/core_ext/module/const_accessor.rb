class Module
  
protected
  
  # Sets a constant and creates an overridable constant accessor at both the class and instance level.
  def const_accessor(sym, value, remove=false, freeze=true)
    value.deepfreeze if freeze
    sym = sym.to_s
    down, up = sym.downcase, sym.upcase
    sym = up.to_sym
    remove_const sym if remove and const_defined? sym
    const_set sym, value
    class_eval "def #{down}; #{up}; end\ndef self.#{down}; #{up}; end"
  end
  
end
