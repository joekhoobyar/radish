require 'date'

class Time
    
  # Returns wday + 7 * Nth for the Nth weekday of this month, for the current date.
  def nwday; day + wday - (day - 1) % 7 - 1 end
    
  # Returns Nth for the Nth weekday of this month, for the current date.
  def nth_wday; (day - 1) / 7 end
    
  # Returns the first weekday of the month.
  def first_wday; (wday - day + 1) % 7 end
    
  # Returns the day of the month for the Nth weekday of this month, starting at week zero.
  def nth_wday_day(w,d)
    1 + (d - (wday - day + 1)) % 7 + w * 7
  end
      
  # Returns a new Time instance for the day of this month returned by +nth_wday(w,d)+.
  def nth_wday_of_month(w, d)
    self + (nth_wday_day(w, d) - day).days
  end
    
  # Returns the day of the month for the Nth weekday of this month, starting at week zero.
  # A single integer is supplied, equaling:  wday + 7 * nth
  def nwday_day(n)
    w = n % 7
    1 + (w - (wday - day + 1)) % 7 + n - w
  end
      
  # Returns a new Time instance for the day of the month returned by +nwday_of_month(n)+.
  def nwday_of_month(n)
    self + (nwday_day(n) - day).days
  end

	# Define methods to check what day of the week it is, like time.monday?
  Date::DAYNAMES.each_with_index { |d, i| define_method("#{d.downcase}?") { wday == i } }
      
  # Return the day name.
  def day_name; Date::DAYNAMES[wday] end
      
  # Return the abbreviated day name.
  def abbr_day_name; Date::ABBR_DAYNAMES[wday] end
      
    
end
