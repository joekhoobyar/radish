class Module
	# Makes all of the included functions protected after including them.
  def protected_include(*mods)
    include *mods
    mods.each { |mod| protected *mod.instance_methods }
  end
end
