class Object # :doc:

	# Convenient access to an object's metaclass.
  def metaclass; (class << self; self; end) end
  alias :__metaclass__ :metaclass
  
  # Evaluates a block in the context of the metaclass instance.
  def meta_eval(string=nil, filename='(eval)', lineno=1, &blk)
    if block_given?
      (class << self; self; end).__instance_eval__(&blk)
    else
      (class << self; self; end).__instance_eval__(string, filename, lineno)
    end
  end
  alias :__meta_eval__ :meta_eval
  
  # Evaluates a block in the context of the metaclass class.
  def metaclass_eval(string=nil, filename='(eval)', lineno=1, &blk)
    if block_given?
      (class << self; self; end).__class_eval__(&blk)
    else
      (class << self; self; end).__class_eval__(string, filename, lineno)
    end
  end
  alias :__metaclass_eval__ :metaclass_eval
  
  # Adds methods to a metaclass
  def meta_def(name, &blk)
    (class << self; self; end).__instance_eval__ { __define_method__(name, &blk) }
  end
  alias :__meta_def__ :meta_def
  
end
