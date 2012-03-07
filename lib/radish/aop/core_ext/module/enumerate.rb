require 'facets/functor'

class Module
  def enumerate items=nil
    if items.empty?
      Functor.new{|symbol,*args| yield items.shift, symbol, *args unless items.empty? }
    end
  end
end
