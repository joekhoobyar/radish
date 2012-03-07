module Radish::AttrMarshal
  
  # An all-purpose target wrapper.
  class Wrapper
    @@cache ||= ::Radish::WeakKeyedCache.new
    
    # Create a new target wrapper.
    def initialize(target,includes)
      @target, @includes = target, includes
    end
    
    # Wrap a target, if necessary.
    def self.wrap(target)
      v = @@cache[target]
      return (v==:_raw) ? target : v if v
      includes = target.__singleton_included_modules__
      @@cache[target] = (includes.empty? ? :_raw : target=new(target, includes))
      target
    end
    
    # Unwraps this target.
    def unwrap
      unless @extended
        @target.__extend__(*@includes)
        @extended = true
      end
      @target
    end
  end
  
  # Ruby will call this to ask us what data we want to marshal.
  # This is much better than defining _dump(), if your object graph cannot be defined as a tree.
  # ActiveRecord object graphs are never trees if they have any associations defined and instantiated.  
  def marshal_dump
    mth = marshal_options[:on_marshal]  
    Method.send_or_call mth, self if mth
    t = []
    marshal_ivars.each do |a|
      t.push a, ::Radish::AttrMarshal::Wrapper.wrap(instance_variable_get(a))
    end
    t
  end
  
  # Ruby will call this to ask us what data we want to marshal.
  # This is much better than defining _load(), if your object graph cannot be defined as a tree.
  # ActiveRecord object graphs are never trees if they have any associations defined and instantiated.  
  def marshal_load(v)
    until v.empty?
      d = v.pop
      a = v.pop.to_sym
      d = d.unwrap if ::Radish::AttrMarshal::Wrapper === d
      instance_variable_set(a, d) if marshal_ivars.include? a
    end
    mth = marshal_options[:on_unmarshal]  
    Method.send_or_call mth, self if mth
  end
  
  # Convenience method.
  def marshal
    Marshal.dump self
  end
end

class Class

	# Call this for configurable marshaling.
	def attr_marshal(*args)
		args = args.map { |sym| Symbol===sym ? sym.to_s : sym }
		
		const_accessor :MARSHAL_OPTIONS, ((Hash === args.last) ? args.pop : {})
		const_accessor :MARSHAL_VARS, args
		const_accessor :MARSHAL_IVARS, Set.new(args.map { |k| "@#{k}".to_sym })
		
		include        ::Radish::AttrMarshal
	end

end

class String

	def unmarshal
		Marshal.load self
	end

end
