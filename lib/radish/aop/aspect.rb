module Radish::AOP
  
  class Aspect
	  
	  attr_reader :name
	  
	  def initialize(name=nil)
	    @name = name
	  end
	  
	  def self.write name=nil
	    yield new(name)
	  end
	  
	  def join(*cuttables, &block)
	    cuttables.each do |t|
	      parms = {}
	      
        case t
	      when Array
	        jp = t.dup
	        t = jp.shift
	        t = Object.module_eval '::'+t if t.is_a?(String)
	        parms[:joinpoints] = jp
	      when String
	        t, jp = t.split '#', 2
	        t = Object.module_eval '::'+t
	        parms[:joinpoints] = [jp.to_sym]
	      end
	      
	      unless Cuttable === t
					if Class == t or Class === t then
						t.send :include, Cuttable
					else
						t.extend Cuttable
					end
	      end
	      t.class_eval do
	        cuttable parms do
	          block.call t
	          public_instance_methods(false).each do |sym|
	            accept_advice sym.to_sym unless sym.to_s.starts_with? '__aop'
	          end
	        end
	      end
	    end
	  end
  end
  
end