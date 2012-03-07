class Module

	# Works something like Module#module_function in reverse, by delegating instance methods to existing class methods.
  def public_instance_function(*symbols)
    file, line = *caller(1).first.split(':')[0,2]
    line = line.to_i rescue 0
    symbols.each do |symbol|
      sig = method(symbol).signature(true)
      arg = ",#{sig}" unless sig.blank?
      module_eval(<<-EOS, file, line)
        def #{symbol}(#{sig})
          self.class.__send__(:#{symbol}#{arg})
        end
      EOS
    end
  end
end


