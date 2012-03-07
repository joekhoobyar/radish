class String
  
  # Pluralize this string only if number == 1
  def pluralize_if(number)
    number==1 ? self : pluralize
  end
  
end
