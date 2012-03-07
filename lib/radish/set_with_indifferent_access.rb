require 'set'

class Set
    
  # Just like a hash with indifferent access.
    def with_indifferent_access
      h = @hash.with_indifferent_access  
      s = ::Set.new
      s.instance_eval { @hash = h }
      s
    end
    
    # Makes the change in-place.
    def with_indifferent_access!
      @hash = @hash.with_indifferent_access  
      self
    end

end

class SetWithIndifferentAccess < Set

  def initialize(enum = nil, &block)
    @hash ||= HashWithIndifferentAccess.new
    super(enum, &block)
  end

protected

  def flatten_merge(set, seen = SetWithIndifferentAccess.new)
    super(set, seen)
  end

  # Sadly, the ruby code isn't doing self.class.new
  #
  # See Set#^
  def ^(enum)
    enum.is_a?(Enumerable) or raise ArgumentError, "value must be enumerable"
    n = self.class.new(enum)
    each { |o| if n.include?(o) then n.delete(o) else n.add(o) end }
    n
  end

end

