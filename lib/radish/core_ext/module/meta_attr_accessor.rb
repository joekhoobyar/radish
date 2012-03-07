class Module
  
protected
  
  # Define a meta-class attribute writer.
  def metaattr_writer(*syms)
    syms.pop if syms.last === true
    metaclass_eval { attr_writer(*syms) }
  end
  
  # Define a meta-class attribute reader.
  # Pass 'true' as the last parameter to optionally search superclasses.
  def metaattr_reader(*syms)
    search = syms.pop if syms.last === true
    return metaclass_eval { attr_reader(*syms) } unless search
    syms.each do |sym|
      if search
        class_eval "def self.#{sym}; @#{sym} ||= (!instance_variable_defined?(:@#{sym}) && superclass.respond_to?(:#{sym})) ? superclass.#{sym} : nil end"
      else
        metaclass_eval { attr_reader(sym) }
      end
    end
  end
  
  # Define a meta-class attribute accessor.
  # Pass 'true' as the last parameter to optionally search superclasses in the reader.
  def metaattr_accessor(*syms)
    metaattr_reader(*syms)
    metaattr_writer(*syms)
  end
  
end
