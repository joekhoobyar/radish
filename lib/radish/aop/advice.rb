require 'abstract'

require 'ruby2ruby'
require 'parse_tree_extensions'

Kernel.class_eval do

module_function

	def called_FILE
		caller[1].split(':',2).first
	end

	def called_LINE
		caller[1].split(':',3)[1]
	end

	def called_SEXP(o, m, l=[])
		file, line, unused = caller[1].split(':',3)
		Sexp.new :called, Sexp.new(:const, (o.is_a?(Module) ? o : o.class).name), m, l.shift, l, [file, line]
	rescue NoMethodError => e
		raise unless e.message =~ /^You have a nil object/
		Sexp.new nil
	end
end

false and [Kernel, Object].inject(%{
	alias :original_method_added  :method_added
	alias :original_singleton_method_added  :singleton_method_added
private
	def method_added(*l)
		original_method_added(*l)
	end
	def singleton_method_added(*l)
		original_singleton_method_added(*l)
	end}) { |code, klass| klass.module_eval code, __FILE__, __LINE__ }


false and Kernel.class_eval do
private
	def method_added(*l) $stderr.puts 'method_added: '+called_SEXP(self, :method_added, l).inspect end
	def singleton_method_added(*l) $stderr.puts 'method_added: '+called_SEXP(self, :singleton_method_added, l).inspect end
	def self.method_added(*l) $stderr.puts 'method_added: '+called_SEXP(self, :method_added, l).inspect end
	def self.singleton_method_added(*l) $stderr.puts 'method_added: '+called_SEXP(self, :singleton_method_added, l).inspect end
end

# Advice that needs to remain tied to it's own idea of "self".
module Radish::AOP

  class Advice < Proc
	  def self.from(advice)
	    new { |target,sym,*args| advice.call(target,sym,*args) }
	  end
	end
	
	# Abstract advisor.
	class AbstractAdvisor
	  
	  abstract_method 'advice', :wrap_advice
	  abstract_method 'sym, dfr', :apply_advice
	  abstract_method 'point', :symbol
	  protected :symbol
	  attr_reader :target
	  
	  def initialize(target)
	    @target = target
	    @queue = Hash.new do |h,k| h[k] = [] end
	  end
    
    # Returns the production queue for the given transition state.
    def queue(state) @queue[state] end
      
    # Defines transitition states for this advisor.
    def when_transitioning_to(state, *advice)
      if advice.length==1 then @queue[state].push(advice.first) else
        @queue[state].concat(advice.map { |a| wrap_advice a })
      end
      self
    end
    
    class_eval(%w(pre post inside outside catch reraise).map { |k|
	      "def #{k}(advice) when_transitioning_to(:#{k}, *advice) unless advice.empty? end"
      }.join("\n"))
    
	end

	# Poorly performig advisor using auto-generated delegate methods.
	class MethodGeneratingAdvisor < AbstractAdvisor
	  
	  # No likey.
	  @@hash ||= (Process.pid ** 2 + Time.now.utc.to_i).to_s 16
	  @@nextsym ||= 0
	  
	  def wrap_advice(advice)
	    advice.map { |a| Method === a ? Advice.from(a) : a }
	  end
	  
	  def apply_advice(sym, dfr)
	    
	    # Alias the original method once.
	    org = "__aop_#{sym}".to_sym
	    alias_target org, sym unless target.method_defined? org
	    
	    # Apply each type of advice in succession, with alias balancing.
	    org = %w(inside pre post outside reraise catch).inject(org) do |mth,style|
	      
	      # The alias for the end of the previous chain of this style.
	      org = "__aop_#{style}_#{sym}".to_sym
	      alias_target org, mth unless target.method_defined? org
	      
	      # Apply the advice, realiasing the end of the chain first, so it can be moved afterwards.
	      mth = send "apply_#{style}".to_sym, sym, realias(sym,org), dfr
	      alias_target org, mth
	      
	      # Return the symbol for the next piece of the chain.
	      org
	    end
	    
	    # Now move the target to the end of all of the chains.
	    alias_target sym, org
	  end
	  
	  protected
	  
	  def apply_inside point, mth, dfr
	    apply_chain @queue[:inside], point, mth, dfr
	  end
	  
	  def apply_outside point, mth, dfr
	    apply_chain @queue[:outside], point, mth, dfr
	  end
	  
	  def apply_reraise point, mth, dfr
	    callables(@queue[:reraise], point, dfr) do |p,advice|
	      k = symbol(point)
	      b = advice_invocation point, p, advice, 'e'
	      advice_eval k, "#{mth}(*args)\nrescue Exception =&gt; e\n  #{b}\n  raise e"
	      mth = k
	    end
	    mth
	  end
	  
	  def apply_catch point, mth, dfr
	    callables(@queue[:catch], point, dfr) do |p,advice|
	      k = symbol(point)
	      b = advice_invocation point, p, advice, 'e'
	      advice_eval k, "#{mth}(*args)\nrescue Exception =&gt; e\n  #{b}"
	      mth = k
	    end
	    mth
	  end
	  
	  def apply_pre point, mth, dfr
	    m = symbol(point)
	    b = callables(@queue[:pre], point, dfr) do |p,advice|
			  advice_invocation(point, p, advice)+" != false and \n  "
		  end.join
		  advice_eval m, "#{b}#{mth}(*args)"
		  m
		end
	    
		def apply_post point, mth, dfr
		  m = symbol(point)
		  b = callables(@queue[:post], point, dfr) do |p,advice|
		    advice_invocation point, p, advice
	    end.join("\n")
	    advice_eval m, "r = #{mth}(*args)\n  #{b}\n  r"
	    m
	  end
	      
	  def apply_chain chain, point, mth, dfr
	    callables(chain, point, dfr) do |p,advice|
	      k = symbol(point)
	      b = advice_invocation point, p, advice, "method(:#{mth})"
	      advice_eval k, b
	      mth = k
	    end
	    mth
	  end
	      
	  def callables(advice, point, dfr)
	    return advice.dup unless block_given?
	    advice.map do |a|
        case a
        when Symbol, String
	        yield a, nil
	      else
	        p = symbol(point)
	        dfr.call p, *a
	        target.send :protected, p
	        yield p, a
	      end
	    end
		rescue Exception => e
			$stderr.puts "#{e} (#{e.class})\n\t#{e.backtrace.join "\n\t"}"
			exit -1
	  end
	      
	  def realias(point, org)
	    k = symbol(point)
	    alias_target k, org
	    k
	  end
	      
	  def advice_invocation point, p, advice, *extras
	    extras = ['self', ':'+point.to_s] + extras if Advice === advice or String === p
	    "#{p}(#{extras.map{|e|e+','}}*args)"
	  end

	  def alias_target newsym, oldsym, access=:protected
      #$stderr.puts "alias_target: #{target}.alias_method :#{newsym}, :#{oldsym}" 
			begin
				target.send :alias_method, newsym, oldsym
			rescue NameError
				target.metaclass.send :alias_method, newsym, oldsym
			end
	  end
	      
	  def advice_eval sym, code, access=:protected
      #$stderr.puts "advice_eval: def #{target}.#{sym}(*args)\n  #{code}\nend"
	    target.pointcut_eval "def #{sym}(*args)\n  #{code}\nend"
	  end

    if RAILS_ENV == 'xtest'
      @@junk = Hash.new do |h,k| h[k] = Class.new(k).instance_eval { const_defined? :Cuttabled or const_set :Cuttabled, true; self } end

      alias_method :alias_target_without_test, :alias_target
	    def alias_target newsym, oldsym, access=:protected
        if Module === @target and @target.name =~ /^Spec(::.*)?$/
		      Radish.logger.debug "test mode(disabled: RAILS_ENV=test): &lt;cuttable: #{target}&gt;.alias_target #{newsym.inspect}, #{oldsym.inspect}, #{access.inspect}\nend}" if Radish.logger.debug?
	        #@target.const_defined? :Cuttabled or @target = @@junk[@target]
        else
	        alias_target_without_test newsym, oldsym, access
        end
		  end

      alias_method :advice_eval_without_test, :advice_eval
      def advice_eval sym, code, access=:protected
        if Module === @target and @target.name =~ /^Spec(::.*)?$/
		      Radish.logger.debug "test mode(disabled: RAILS_ENV=test): &lt;cuttable: #{target}&gt;.class_eval %Q{def #{sym}(*args)\n  #{code}\nend}, #{access.inspect}" if Radish.logger.debug?
        else
          #@target.const_defined? :Cuttabled or @target = @@junk[@target]
          advice_eval_without_test sym, code, access
			  end
		  end
    end
	      
	  def symbol(point)
	    k = "__aop_#{@@nextsym}__#{point}"
	    @@nextsym += 1
	    k.to_sym
	  end
	end
	
	class TransformingAdvisor < AbstractAdvisor
	end
	
	class SexpAdvisor < AbstractAdvisor
	end

  Advisor = MethodGeneratingAdvisor
end
