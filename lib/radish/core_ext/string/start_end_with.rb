class String
  
  # Checks if this string starts with the given string.
  #
  # CREDIT:   Joe Khoobyar <joe@khoobyar.name>
  #
  def start_with?(str)
    str = str.to_str
    str == left(str.length)
  end
  
  # Checks if this string ends with the given string.
  #
  # CREDIT:   Joe Khoobyar <joe@khoobyar.name>
  #
  def end_with?(str)
    str = str.to_str
    str == right(str.length)
  end

end
