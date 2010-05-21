class Train < ActiveRecord::Base

  # last_seen_time
  # travelled_length
  # line_name

  VELOCITY = 50

  def update_travelled_length(time_at)
    self.last_seen_time ||= Time.now
    self.travelled_length = (time_at - last_seen_time) * VELOCITY
    self.last_seen_time = time_at
    save
  end

  def distance_from_base_station
    if (travelled_length / line_length).odd?
      travelled_length % line_length
    else
      line_length - travelled_length % line_length
    end
  end

  def line_length
    LINES[line_name].last
  end

  def coords
    update_travelled_length(Time.now)

    pos = distance_from_base_station
    stations_from_0 = station_distances.select {|d| d < pos}
    Coords.get(line_name, stations_from_0.size, pos - stations_from_0.last)
  end

end
