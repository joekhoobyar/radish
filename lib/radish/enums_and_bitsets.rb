module Radish::EnumsAndBitsets
  
  protected
  
  # Creates an enumeration of constants from the given block.
  def const_enumeration(symbols, prefix=nil, &block)
    prefix = cprefix.to_s.upcase+'_' if prefix
    symbols.each_with_index do |sym,i|
      const_set "#{prefix}#{sym.to_s.upcase}", block_given? ? block.call(sym, i) : i
    end
  end
  
  # Creates an enumeration of bitfield constants plus tester methods.
  def const_enum_and_bitset(var, names, options={})
    options = {:track_states=>false, :expanded_inspect=>true, :instance_variable=>true}.merge(options)
    cprefix = options[:const_prefix] || options[:prefix]
    cprefix = cprefix.to_s.upcase+'_' if cprefix.is_a?(Symbol)
    tprefix = options[:tester_prefix] || options[:prefix]
    tprefix = tprefix.to_s+'_' if tprefix.is_a?(Symbol)
    
    
    # Set up an attribute accessor, if we're using an instance variable.
    if options[:instance_variable]
      attr_accessor var
      att = "@#{var}"
    else
      att = "self.#{var}"
    end
    
    # Flag constants and tester methods.
    expanded = []
    names.each_with_index do |sym,i|
      k = "#{cprefix}#{sym.to_s.upcase}"
      const_set "BITIDX___#{k}", i
      n = 1 << i
      const_set k, n
      class_eval "def #{tprefix}#{sym.to_s.downcase}?; (#{att} & #{n}) != 0; end"
      if options[:track_states]
        class_eval "def #{tprefix}#{sym.to_s.downcase}=(v); v ? set_#{var}=(#{n}) : reset_#{var}=(#{n}); v; end"
      elsif ! options[:readonly]
        class_eval "def #{tprefix}#{sym.to_s.downcase}=(v); v ? (#{att} |= #{n}) : (#{att} &= ~#{n}); v; end"
      end
      expanded << k
    end
    
    # Initializers and state change accessors.
    if options[:track_states]
      attr_reader "set_#{var}"
      class_eval "def set_#{var}=(v); #{att} |= v; @reset_#{var} &= ~v; @set_#{var} |= v; v; end"
      attr_reader "reset_#{var}"
      class_eval "def reset_#{var}=(v); #{att} &= ~v; @set_#{var} &= ~v; @reset_#{var} |= v; v; end"
      class_eval "private; def init_#{var}(v=nil, default=0); v ||= default; #{att} = v; @set_#{var} = default & ~v; @reset_#{var} = ~default & v; v; end"
    elsif ! options[:readonly]
      class_eval "def set_#{var}=(v); #{att} |= v; v; end"
      class_eval "def reset_#{var}=(v); #{att} &= ~v; v; end"
      class_eval "private; def init_#{var}(v=nil, default=0); #{att} = v || default; v; end"
    end
    
    # Override inspect to provide nicer output.
    if options[:expanded_inspect]
      l = options[:expanded_inspect] unless options[:expanded_inspect]===true
      l = (l || "#{var}_names").upcase
      const_set l, expanded
      vars = var.to_s
      vars += "|set_#{var}|reset_#{var}" if options[:track_states]
      alias_method "inspect_without_expanded_#{var}", :inspect
      class_eval <<-EOS
        def inspect_with_expanded_#{var}
          text = inspect_without_expanded_#{var}
          text.gsub(/@(#{vars})=([0-9]*[^0-9])/) do |match|
            v, b = instance_variable_get('@' + $1), []
            #{l}.each_with_index { |k,i| b << k if (v & (1 << i)).nonzero? } if v
            '@' + $1 + '=' + $2.left(-1) + ' (' + b.join(' | ') + ')' + $2.right(1)
          end
        end
      EOS
      alias_method :inspect, "inspect_with_expanded_#{var}"
    else
      const_set "#{var}_names".upcase, expanded
    end
  end
  
end

Module.send :include, Radish::EnumsAndBitsets
