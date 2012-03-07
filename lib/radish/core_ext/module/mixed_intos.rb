class Module
	# Makes this module keep track of things that it is mixed into.
  # This function will define an attribute reader that returns just that.
  def mixed_intos(sym)
    class_eval <<-eoclass
      @#{sym} ||= []
      class << self
        def included_with_mixed_ins(child) @#{sym} << child end
        alias_method :included_without_mixed_ins, :included
        alias_method :included, :included_with_mixed_ins
        attr_reader :#{sym}
      end
    eoclass
  end
end

