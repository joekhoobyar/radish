class Module

	# Checks to see if this type of module is assignable from another one.
  def assignable_from?(other)
    while other
      return true if other==self
      other = other.superclass
    end
    false
  end

end
