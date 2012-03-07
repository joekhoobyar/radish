class Radish::WeakKeyedCache
	attr_reader :cache
	
	def initialize(cache = Hash.new)
	  @cache = cache
	  @reaper = lambda do |id| @cache.delete id end
	end
	
	def [](key)
	  @cache[key.__object_id__]
	end
	
	def []=(key, value)
	  @cache[key.__object_id__] = value
	  ObjectSpace.define_finalizer(key, @reaper)
	end
end
