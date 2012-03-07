class Module
  # Like Module#module_function, except that the instance methods are made public after being aliased in the module.
  def public_module_function(symbol,*symbols)
    module_function symbol, *symbols
    public symbol, *symbols
  end
end
