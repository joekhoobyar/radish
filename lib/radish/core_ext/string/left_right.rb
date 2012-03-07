class String
  
  # Returns the leftmost n characters of this string.
  # If n is negative, treat it as length + n
  #
  # CREDIT:   Joe Khoobyar <joe@khoobyar.name>
  #
  def left(n)
    n += length if n < 0
    self[0,n]
  end
  
  # Returns the rightmost n characters of this string.
  # If n is negative, treat it as length + n
  #
  # CREDIT:   Joe Khoobyar <joe@khoobyar.name>
  #
  def right(n)
    n += length if n < 0
    self[-n,n]
  end
  
end
