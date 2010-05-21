class Train < ActiveRecord::Base

  # last_seen_time
  # travelled_length
  # line_name

  VELOCITY = 500 # should be 50, and that's real (but boring)

  def update_travelled_length(time_at)
    # TODO handle stops
    self.travelled_distance += (time_at - last_seen_time).to_f * VELOCITY / 3600.0
    self.last_seen_time = time_at
    save
  end

  def distance_from_base_station
    if (travelled_distance / line_length).to_i.even?
      travelled_distance % line_length
    else
      line_length - travelled_distance % line_length
    end
  end

  def station_distances
    Stations.get_line(line_name.to_s).collect {|d| d[:distance]}
  end

  def line_length
    Stations.get_line(line_name.to_s).last[:distance]
  end

  def coords
    update_travelled_length(Time.now)

    pos = distance_from_base_station
    stations_from_0 = station_distances.select {|d| d < pos}
    
    line_stations = STATIONS.select {|s| s[:color] == line_name}
    point1 = line_stations[stations_from_0.size - 1]
    point2 = line_stations[stations_from_0.size]
    train_coordinates(point1[:coordinates], point2[:coordinates], pos - stations_from_0.last)
  end

  def train_coordinates(point1, point2, train_dist)
    delta = train_dist / Stations.get_distance_between(point1, point2)
    [ point1[:lat] + (point2[:lat]-point1[:lat]) * delta, point1[:lng] + (point2[:lng]-point1[:lng]) * delta ]
  end

  before_create :set_last_seen_time
  def set_last_seen_time
    self.last_seen_time ||= Time.now
  end

end
