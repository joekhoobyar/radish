class Method
  
  # Get the target information for a method.
  def target_info
    s = to_s
    raise 'target_class will not work with a redefined Method#to_s' unless s.starts_with? '#<Method: '
    s[10, s.length-10]
  end
  
  # If "mth" is a symbol, send it to the given "inst" as the receiver.
  # Otherwise, call it passing "inst" as the first parameter.
  def self.send_or_call(mth, inst, *args)
    case mth
    when Symbol
      inst.send mth, *args
    else
      mth.call inst, *args
    end
  end

end

class UnboundMethod
  
  # Get the target information for an unbound method.
  def target_info
    s = to_s
    raise 'target_class will not work with a redefined UnboundMethod#to_s' unless s.starts_with? '#<UnboundMethod: '
    s[17, s.length-17]
  end
  
end

module Radish::MethodInfo
	    
	# Get a compatible signature for the method, with an optional block.
	def signature(block=false)
	  n = arity
	  n = -n-1 if v = (n < 0)
	  out = (1..n).map { |i| "a#{i}" }
	  out << 'v' if v
	  out.join ','
	end
	    
	# Get the target class.
	def target_class
	  x = target_info
	  Object.module_eval '::' + x[0,x.index('#')]
	end
	    
	# Get the target name.
	def name
	  x = target_info
	  n = x.index('#') + 1
	  x[n, x.length-n-1]
	end unless method_defined? :name
  
end

Method.send :include, Radish::MethodInfo
UnboundMethod.send :include, Radish::MethodInfo
