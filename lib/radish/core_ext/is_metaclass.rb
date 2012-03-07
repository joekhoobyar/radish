# Detect whether the receiver is a metaclass.
# Does not resort to parsing strings from #inspect.
#
# Tested on Ruby 1.8.6 p114 (Enterprise Edition - Feb. 2009)
#
module Kernel
  def metaclass?; false end
end

class Object
  def self.metaclass?; superclass.object_id == object_id || superclass.metaclass? end
end

class Module
  def metaclass?; false end
  def (class << Module; self; end).metaclass?; true end
end

class NilClass
  def metaclass?; false end
end

class Class
  def metaclass?; true end
  def self.metaclass?; superclass.metaclass? end
  def (class << Class; self; end).metaclass?; true end
end
