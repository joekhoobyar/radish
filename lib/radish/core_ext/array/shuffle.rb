class Array
    
  # Shuffle an array and return the new array.
  def shuffle
    sort_by { rand }
  end
    
  # Shuffle an array in place.
  def shuffle!
    self.replace shuffle
  end

end
