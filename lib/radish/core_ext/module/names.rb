class Module

	# The name of this module's parent module.  Returns +nil+ if there is no parent module.
  def parentname
    s = name
    (i = s.rindex('::')) and s[0,i] unless s.blank?
  end
  
  # The base name of this module.
  def basename
    s = name
    (i = s.rindex('::')) and (s = s.right(-i-2)) unless s.blank?
    s
  end
  method_defined?(:simple_name) or alias_method(:simple_name, :basename)
end

