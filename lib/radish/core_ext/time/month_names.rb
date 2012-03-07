require 'date'

class Time

  # Return the month name.
  def month_name; Date::MONTHNAMES[month] end
      
  # Return the abbreviated month name.
  def abbr_month_name; Date::ABBR_MONTHNAMES[month] end

end 
