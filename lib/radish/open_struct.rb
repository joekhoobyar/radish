require 'ostruct'

# A serializable OpenStruct.
#
# CREDIT:   Joe Khoobyar <joe@khoobyar.name>
#
class Radish::OpenStruct < ::OpenStruct
  
  def initialize(raw=nil,into=nil)
    case raw
    when Hash
      raise ArgumentError unless into.nil?
    super(raw)
    when NilClass
      raise ArgumentError unless into.nil?
      super()
    when String
      super()
      decode(raw, into) unless raw.blank? or raw == '&&'
    else
      raise ArgumentError
    end
  end
  
  def field_names
    @table.keys
  end
  
  def self.decode(raw, into=nil)
    new raw, into
  end
  
  def encode(full=true)
    raw = Radish::URI.encode(@table, full) unless @table.empty?
    raw.blank? ? nil : "&#{raw}&"
  end
  
  def decode(raw, into=nil)
    raise ArgumentError unless (String === raw or raw.nil?) and (Hash === into or into.nil?)
    into = Radish::URI.decode(raw, into || {}) unless raw.blank?
    @table = {}
    for key,value in into
      @table[key.to_sym] = value
      new_ostruct_member(key)
    end unless into.empty?
    self
  end
  
  def ==(other)
    other.class == self.class && @table == other.table
  end
  
end
