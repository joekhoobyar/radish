require File.expand_path("../string/left_right",__FILE__)
require File.expand_path("../string/after",__FILE__)

if RUBY_VERSION =~ /^1\.8/
	require File.expand_path("../array/start_end_with",__FILE__)
end
class String
	alias starts_with? start_with?
	alias ends_with? end_with?
end

if ::Object.class_defined? :Inflector
	require File.expand_path('../string/inflector',__FILE__)
end
