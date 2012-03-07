# a generic mixin for things that respond to :call and :[] like methods do.
module Callable

  module EnumerableMethods

    # Returns a callable implementation with some parameters filld in.
    def fill(arg)
      lambda do |*args| self[*args.unshift(*arg)] end
    end

    def join(*arg)
      if arg.empty? then self else
        arg = arg.inject([]) do |j,a|
          (Pointcut::HOLE == a) ? j : j.push(a)
        end
        (Pointcut::HOLE == a) ? j : j.push(a)
      end

			if $DEBUG
				$stderr.puts(Wrapper.new(intern(*arg), fill(arg)) do |*args|
					$stderr.puts 'dump: '+args.inspect ; end.inspect)
			end
    end
	end

	def self.included(base)
	  base.method_defined? :bind or base.send :abstract_method, 'object', :bind
	  base.method_defined? :join or base.send :include, EnumerableMethods
	end
	not_implemented! 'points, advice=nil', :compose, :compose!
	
	class Wrapper < Functor
	  attr_reader :shadow, :callable
	
	  def initialize(shadow, callable, &block)
	    super(&block)
	    @shadow, @callable = shadow, callable
	  end
	  #def intern(*arg)
	  # SHADOWS[ Radish::Vector.new(*SYMBOLS[shadow].concat(arg)) ]
	  #end
	end
	
	def bind_and_curry(object, args)
	  bind(object).join *args
	end
	
	module Pure
	  not_implemented! 'points, advice=nil', :compose, :compose!
	
	  def pure?; true end
	  def intern(*args)
	    "<#{self.class}>##{inspect}".intern
	  end
	end
end
