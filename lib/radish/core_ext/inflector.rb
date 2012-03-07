if ::Object.class_defined? :Inflector
	require File.expand_path('../string/inflector',__FILE__)
	require File.expand_path('../symbol/inflector',__FILE__)
end
