[Symbol, Fixnum, Float, TrueClass, FalseClass, NilClass].each { |klz| klz.send :include, Callable::Pure }

module Kernel
  def to_class_sym; self.class.to_s.intern end
  def to_metaclass_sym; metaclass.to_s.intern end
  def pure?; false end
end

class Class
  def to_class_sym; to_s.intern end
  alias :intern :to_class_sym
end

[Symbol, Fixnum, String].each { |pure_k| pure_k.class_eval "alias :to_metaclass_sym :to_class_sym" }

[String].each { |pure_k| pure_k.class_eval "def pure?; pure_k == self.class end" }
