require 'set'

# Loose-typing conveniences.
module Radish::LooseTypes
  
	# Nil can have nil.  Nil can be considered empty.
	module Nil
	  def empty?; true end
	  def has_this?(v); v.nil? end
	  def has_these?(*v); v.include? nil end
	  def to_list; [] end
	  def list?; false end
	end
	
	# An object has one of itself.
	module Object
	  def has_this?(v); v == self end
	  def has_these?(*v); v.include? self end
	  def to_list; [self] end
	  def list?; false end
	        
	  # Remove the ruby warning.
	  def to_a; [self] end
	end
	    
	# An list has things too.
	module List
	  def has_this?(v); include? v end
	  def has_these?(*v); any? { |l| v.include? l } end
	  def to_list; self end
	  def list?; true end
	end
	    
	# A map is even nicer.
	module Map
	  def has_this?(v); key? v end
	  def has_these?(*v); keys.any? { |l| v.include? l } end
	  def list?; false end
	end
end

NilClass.send :include, Radish::LooseTypes::Nil
Object.send :include, Radish::LooseTypes::Object
Array.send :include, Radish::LooseTypes::List
Hash.send :include, Radish::LooseTypes::Map
Set.send :include, Radish::LooseTypes::List

# This can simplify some code.
class Symbol
  def empty?; false end
end
