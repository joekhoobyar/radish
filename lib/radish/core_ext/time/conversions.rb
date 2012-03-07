require 'date'

class Time
    
  #
  # CONVERSION METHODS
  #
      
  # Convert to an integer, where the year, month and day each have their own decimal place:  YYYYMMDD
  # Similar in spirit to BCD format numbers.
  def to_ymdi; year * 10000 + month * 100 + day end
      
  # Convert to an integer combining year and month which increases by 1 and only 1, for each successive month.
  def to_ymi; year * 12 + month - 1 end

  # Convert to an integer combining year, month and day which increases by 1 and only 1, for each successive day.
  def to_dayi; (to_i + utc_offset) / 86400 end

  # Return the time portion of this date, as an integer, in seconds.
  def to_timei; (to_i + utc_offset) % 86400 end

  # Create a new Time instance from +i+, such that:  new_time.to_ymi == i
  def self.ymi(i); mktime i / 12, i % 12 + 1 end

  # Create a new Time instance from +i+, such that:  new_time.to_ymdi == i
  def self.ymdi(i)
    m = i / 100
    mktime m / 100, m % 100, i % 100
  end

  # Create a new Time instance from +i+, such that:  new_time.to_dayi == i
  def self.dayi(i)
    t = at(i * 86400)
    t - t.utc_offset
  end
end
