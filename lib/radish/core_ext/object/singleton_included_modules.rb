class Object # :doc:

  # A list of modules included only at the singleton level.
  def singleton_included_modules;
    (class << self; self; end).__included_modules__ - __class__.__included_modules__
  end
  alias :__singleton_included_modules__ :singleton_included_modules
  
end
