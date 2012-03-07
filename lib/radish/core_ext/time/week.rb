require 'date'

class Time
    
  # Week of the year, starting at zero.
	def yweek; (yday - wday) / 7 + 1 end
      
  # Week of the month, starting at zero.
	def mweek; (5 - wday + day) / 7 end
	  
  # Sunday, in the same week.
	def start_of_week; self - wday.days end
	  
  # Saturday, in the same week.
	def end_of_week; self + (6 - wday).days end
      
  # Odd-numbered week test, since Epoch.
  def odd_week?; (to_i / 7.days).odd? end
end
