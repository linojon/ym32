require 'spec_helper'
require "hebrew_date"

describe Hebruby::HebrewDate do
  it "should parse a hebew date string" do
    date = Hebruby::HebrewDate.parse("16 Av 5760")
    date.day.should == 16
    date.month.should == 5
    date.year.should == 5760
  end
  it "should compare ==" do
    date = Hebruby::HebrewDate.new(16,5,5760)
    date2 = Hebruby::HebrewDate.new(16,5,5760)
    (date == date2).should be_true
  end
  it "should compare <" do
    date = Hebruby::HebrewDate.new(16,5,5760)
    date2 = Hebruby::HebrewDate.new(17,5,5760)
    (date < date2).should be_true
  end
  it "should compare >" do
    date = Hebruby::HebrewDate.new(16,5,5760)
    date2 = Hebruby::HebrewDate.new(15,5,5760)
    (date > date2).should be_true
  end
    
  it "should to_s" do
    date = Hebruby::HebrewDate.new(16,5,5760)
    date.to_s.should == "16 Av 5760"
  end
  
  it "should to_s(:day_month)" do
    date = Hebruby::HebrewDate.new(16,5,5760)
    date.to_s(:day_month).should == "16 Av"
  end
end
