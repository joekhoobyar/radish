require 'date'

class Time
    
  # Start of the quarter.
  def start_of_quarter; ::Time.gm year, month - (month + 2) % 3, 1 end
      
  # End of the quarter (TODO: write a better version of this).
  def end_of_quarter; start_of_quarter.months_since(3) - 1 end

end
