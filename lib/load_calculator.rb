module LoadCalculator
  
  AVERAGE_DAILY = 1_700_000
  
  RUSH_HOURS = [7.hours..(9.hours + 30.minutes), (17.hours + 30.minutes)..19.hours]
  MID_HOURS  = [6.hours..7.hours, 20.hours..24.hours]
  ZERO_HOURS = [0.hours..6.hours]

  def base_people_count
    1550 + rand(1000)
  end

  def total_people_at(time)
    time_offset = time.hour.hours + time.min.minutes
    case time_offset
    when *RUSH_HOURS
      base_people_count * 2
    when *MID_HOURS
      base_people_count / 3
    when *ZERO_HOURS
      0
    else
      base_people_count
    end
  end

  def total_in_other_hours
    0.upto(24).inject(0) do |counter,n|
      counter += total_people_at(Time.now.at_beginning_of_day + n.hours)
    end
  end

end