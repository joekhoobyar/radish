class Module
  
  # Defines an instance method within a class
  def class_def(name, &blk)
    __class_eval__ do
      __define_method__(name, &blk)
    end
  end
  alias :__class_def__ :class_def

end
