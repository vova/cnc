require 'spec_helper'
require 'load_calculator'

def time_offset(seconds_from_start)
  Time.now.at_beginning_of_day + seconds_from_start
end

describe LoadCalculator do  
  
  include LoadCalculator
  
  describe "total_people_at(time)" do
    
    context "unless time is rus or mild time" do
      it "should return 2050+/-500" do
        not_rush_not_mild = time_offset 12.hours
        (total_people_at(not_rush_not_mild) <= 2550).should be_true
        (total_people_at(not_rush_not_mild) >= 1550).should be_true
      end
    end
    
    context "should return 0 when metro closed (00:00..06:00)" do
      it "should return 0" do
        zero_hour = time_offset 2.hours
        total_people_at(zero_hour).should == 0
      end
    end
    
    context "in rush hours" do
      it "should return base * 2" do
        load = total_people_at(time_offset 7.hours + 30.minutes)        
        (load >= 1550 * 2).should be_true
        (load <= 2550 * 2).should be_true
      end
    end
    
    context "in mid hours" do
      it "should return base / 3" do
        load = total_people_at(time_offset 6.hours + 30.minutes)        
        (load >= 1550 / 3).should be_true
        (load <= 2550 / 3).should be_true
      end
    end
  end
end