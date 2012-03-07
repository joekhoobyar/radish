module Radish
  module AOP
	  
	  module Cuttable
	
			module Continously
				DIAMONDS = SetWithIndifferentAccess.new %w(class subclass instance_eval class_eval metaclass metaclass_eval meta_eval pointcut_eval advice_eval alias_target alias_method)
	
				def singleton_method_added sym
					accept_advice sym unless @cutting.nil? or DIAMONDS.include? sym
				end
			end
	
			module ClassMethods
				def cuttable parms={}, &amp;block
					return if cutting?
					old, @joinpoints = joinpoints, parms[:joinpoints]
					return unless block
					block.call self
					@advisor = nil
					@joinpoints = old
				end
			end
	
	 	  def self.included base
				#$stderr.puts 'included: '+base.to_s
		    #base.class_eval do
		    #  respond_to? :advisor_klass= or cattr_accessor :advisor_klass
		    #  method_defined? :pointcut_eval or metaclass.send :alias_method, :pointcut_eval, :class_eval
		    #end
			  #base.advisor_klass ||= ::Radish::AOP::Advisor
				base.metaclass.send :include, ClassMethods
				base.extend self
		  end
	  
		  def self.extended base
	      base.class_eval do
				  respond_to? :advisor_klass= or attr_accessor :advisor_klass
					alias_method :pointcut_eval, :instance_eval
		    end
				base.extend ClassMethods
			  base.advisor_klass ||= ::Radish::AOP::Advisor
		  end
		  
	    attr_accessor :joinpoints, :cutting
	    private       :cutting=
	
	    def cutting?
	      ! cutting.nil?
	    end
		  
		  def advisor type=nil, *args
		    return @advisor if (@advisor and (cutting? or type.nil? or type===@advisor.class))
		    args.unshift self
		    @advisor = (type || advisor_klass || Advisor).new(*args)
		  end
		  
		  def advise *args
		    advisor.send args.shift, args
		  end
		  
		  def matches_joinpoints? sym
		    return true if joinpoints.nil?
		    s = sym.to_s
		    joinpoints.each do |jp|
	        return true if case jp when String;  s == jp
										      when Symbol;  sym == jp
											    when Regexp;  s =~ jp
									        end
		    end
		    false
		  end
		  
		protected
		  
		  def accept_advice sym
		    if matches_joinpoints? sym then begin
			    self.cutting = sym
		      define_advice sym
		    ensure
			    self.cutting = nil
			  end; end
		  end
	
	  private
	  
	    def define_advice sym
		    advisor.apply_advice sym, method(:define_method)
	    end
		end
		
		::Class.extend Cuttable
		::Module.extend Cuttable
		::Kernel.extend Cuttable
	end
end
