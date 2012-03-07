require 'set'

module Radish::URI
  
  module_function
  
  URI_ITEM_ENCODER = lambda { |x| '%' + x.unpack('H2' * x.size).join('%').upcase }
  
  # A recursive uri encoder, handling scalars, hashes, sets and arrays.
  # By default, it does a "full" encode, via CGI::escape().
  # Scalars are converted to strings via +to_s+.
  #
  # CREDIT: Joe Khoobyar <joe@khoobyar.name>
  #
  def encode(item, full=true, key=nil)
    case item
    when Hash
      item.map do |k,v|
        k = full ? CGI::escape(k.to_s) : k.to_s.gsub(/[=&%\[\]]/, &URI_ITEM_ENCODER)
        k = "#{key}[#{k}]" if key
        encode(v, full, k)
      end.join('&')
    when Array, Set
      item.map { |v| encode(v, full, "#{key}[]") }.join('&')
    else
      item = full ? CGI::escape(item.to_s) : item.to_s.gsub(/[=&%]/, &URI_ITEM_ENCODER)
      key ? "#{key}=#{item}" : item
    end
  end
    
	# A recursive uri decoder, handling strings, hashes, sets and arrays.
	#
	# CREDIT: Joe Khoobyar <joe@khoobyar.name>
	#
	def decode(raw, table={})
	  n = -1
	  while n and (m = n + 1) < raw.length
	    n = raw.index('&', m)
	    next if m == n
	    n ||= raw.length
	    q = raw.index('=', m)
	    next if !q or q > n
	        
	    a = raw.index('[', m)
	    idx = CGI::unescape(raw[m, (a && a<n ? a : q)-m])
	    into = table
	    while into and a and a < q and (b = raw.index(']', a)) and b < q
	      path = idx
	      idx = CGI::unescape(raw[a+1, b-a-1])
	      into = (into[path] ||= (idx.size.zero? ? [] : {}))
	      into = nil unless (idx.size.zero? ? Array : Hash) === into
	      a = raw.index('[', b + 1)
	    end
	        
	    v = CGI::unescape(raw[q+1, n-q-1])
	    case into
      when Hash
        into[idx] = v
      when Array
	      into << v
	    end
	  end
	  into
	end
end
