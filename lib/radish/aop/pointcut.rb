module Pointcut

	def advice; @advice end
	def advice=(a); @advice = a end
	
	HOLE = Object.new.freeze
	ITER = Object.new.freeze
	LIT = Object.new.freeze
	REF = Object.new.freeze
	
	implements JoinPoint do
	  def weave arg=nil
	    if Advice === arg then compose(arg) else
	      arg.nil? ? join : join(arg)
	    end
	  end
	
	  def weave! advice
	    replace [compose(advice)]
	    self
	  end
	end
end
