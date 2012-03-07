module TypeCast
  
  module Boolean
    def self.cast_from(object, loose=false)
      case object
      when TrueClass
        true
      when FalseClass, NilClass
        false
      when Numeric
        ! object.zero?
      when String
        case object.downcase
        when '','f','false','off','no','0'
          false
        when 't','true','on','yes','1'
          true
        else
          return true if loose
          loose || cast_from(TypeCast::Integer.cast_from(object))
        end
      else
        if object.respond_to? :to_bool
          object.to_bool
        elsif object.respond_to? :to_boolean
          object.to_boolean
        elsif object.respond_to? :empty?
          ! object.empty?
        elsif object.respond_to? :blank?
          ! object.blank?
        else
          loose || cast_from(String.cast_from(object), loose)
        end
      end
    end
    
    module Any
      def self.cast_from(object)
        TypeCast::Boolean.cast_from(object, true)
      end
    end
  end
  
  module Tristate
    def self.cast_from(object, loose=false)
      TypeCast::Boolean.cast_from(object, loose) unless object.nil? or
                      (object.respond_to?(:empty?) && object.empty?) or
                			(object.respond_to?(:blank?) && object.blank?)
    end
    
    module Any
      def self.cast_from(object)
        TypeCast::Tristate.cast_from(object, true)
      end
    end
  end
  
  module Integer
    def self.cast_from(object, loose=false)
      return ::Integer.cast_from(object) unless !loose and String === object
      from_string(object)
    end

    def self.from_string(object)
      if object[0] != ?0
        DecimalNotation.from_string(object)
      elsif object[1] == ?x or object[1] == ?X
        HexadecimalNotation.from_string(object)
      else
        OctalNotation.from_string(object)
      end
    rescue TypeCastException => e
      e
      raise TypeCastException, "'#{object}' is not recognizable as an integer"
    end
    
    module OctalNotation
      def self.cast_from(object)
        return ::Integer.cast_from(object) unless String === object
        from_string(object)
      end

      def self.from_string(object)
        return object.oct if object.count('^0-7').zero?
        raise TypeCastException, "'#{object}' is not in octal notation"
      end
    end
    
    module DecimalNotation
      def self.cast_from(object)
        return ::Integer.cast_from(object) unless String === object
        from_string(object)
      end

      def self.from_string(object)
        return object.to_i(10) if object.count('^0-9').zero?
        raise TypeCastException, "'#{object}' is not in decimal notation"
      end
    end
    
    module HexadecimalNotation
      def self.cast_from(object)
        return ::Integer.cast_from(object) unless String === object
        from_string(object)
      end

      def self.from_string(object)
        n = object.count('^0-9a-fA-F')
        return object.hex if n.zero? or (n == 1 and (object[1] == ?x or object[1] == ?X))
        raise TypeCastException, "'#{object}' is not in hexadecimal notation"
      end
    end
  end
  
end
