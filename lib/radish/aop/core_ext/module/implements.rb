# helpers for defining an interface.
class Module

  def implements(*k)
    class_eval{ yield ; include *k }
  end

  # shorthand for defining many unimplemented interface methods.
  def not_implemented!(*k)
    args = k.shift if String === k.first
    (@interface_methods ||= Set.new).merge k
    module_eval( k.map { |sym| "def #{sym}(#{args || '*args'}) not_implemented end" }.join("\n\n\t"))
    @interface_methods
  end
end

