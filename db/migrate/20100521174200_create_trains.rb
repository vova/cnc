class CreateTrains < ActiveRecord::Migration
  def self.up
    create_table :trains do |t|
      t.timestamp :last_seen_time
      t.integer   :travelled_distance, :default => 0
      t.string    :line_name
    end
  end

  def self.down
    drop_table :trains
  end
end
