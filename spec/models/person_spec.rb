require 'spec_helper'

describe Person do
  describe "last_name" do
    it "must be > 1 character" do
      FactoryGirl.build(:person, :last_name => 'A').should_not be_valid
    end
   it_should_behave_like "a proper name", FactoryGirl.build(:person), :last_name
  end
  describe "first_name" do
    it_should_behave_like "a proper name", FactoryGirl.build(:person), :first_name
  end
  describe "middle_name" do
    it_should_behave_like "a proper name", FactoryGirl.build(:person), :middle_name
  end
  describe "maiden" do
    it_should_behave_like "a proper name", FactoryGirl.build(:person), :maiden
  end
  describe "gender" do
    it "only allows 'male' and 'female'" do
      FactoryGirl.build(:person, :gender => 'male').should be_valid
      FactoryGirl.build(:person, :gender => 'female').should be_valid
      FactoryGirl.build(:person, :gender => 'foo').should_not be_valid      
    end
    it "is not required" do
      FactoryGirl.build(:person, :gender => '').should be_valid
      FactoryGirl.build(:person, :gender => nil).should be_valid
    end
  end
  describe "prefix" do
    it "only allows stanard prefixes" do
      %w{ Ms Miss Mrs Mr Dr Atty Prof Hon Gov Ofc Rabbi Cantor }.each do |prefix|
        FactoryGirl.build(:person, :prefix => prefix).should be_valid
      end
    end
    it "is not required" do
      FactoryGirl.build(:person, :prefix => '').should be_valid
      FactoryGirl.build(:person, :prefix => nil).should be_valid
    end
  end
  
  describe "death date" do
    it "cannot be before birth date" do
      person = FactoryGirl.build(:person)
      person.death_date = person.birth_date - 1.day
      person.should_not be_valid
      person.errors[:death_date].should include("can't be before birth date")
    end
    it "calculates death_hebrew_date on save" do
      person = FactoryGirl.build(:person, :death_date => "2000/08/17")
      person.death_hebrew_date_day.should be_nil
      person.death_hebrew_date_month.should be_nil
      person.death_hebrew_date_year.should be_nil
      
      person.save
      person.death_hebrew_date_day.should == 16
      person.death_hebrew_date_month.should == 5
      person.death_hebrew_date_year.should == 5760
    end
    it "calculates death_hebrew_date as next day if after sunset" do
      person = FactoryGirl.build(:person, :death_date => "2000/08/17", :death_after_sunset => true )
      person.save
      person.death_hebrew_date_day.should == 17
      person.death_hebrew_date_month.should == 5
      person.death_hebrew_date_year.should == 5760
    end
  end
  
  describe "death_hebrew_date" do
    it "calculates western death_date on save" do
      person = FactoryGirl.build(:person, :death_date => nil, :death_hebrew_date_day => 16, :death_hebrew_date_month => 5, :death_hebrew_date_year => 5760)
      person.death_date.should be_nil
      person.save
      person.death_date.should == Date.parse("2000/08/17")
    end
    it "calculates western death_date as day before if after sunset" do
      person = FactoryGirl.build(:person, :death_date => nil, :death_hebrew_date_day => 16, :death_hebrew_date_month => 5, :death_hebrew_date_year => 5760, :death_after_sunset => true)
      person.save
      person.death_date.should == Date.parse("2000/08/16")
    end
    # ref: http://www.hebcal.com/converter
    it "is a hebdate" do
      person = FactoryGirl.create(:person, :death_date => "2000/08/17")
      person.death_hebrew_date.jd.should == Hebruby::HebrewDate.new(16,5,5760).jd
    end
    it "can find by hebrew month" do
      person = FactoryGirl.create(:person, :death_date => "2000/08/17")
      Person.where(:death_hebrew_date_month => 5).should == [person]
    end
    it "is nil given yahrzeit date (without year)" do
      person = FactoryGirl.create(:person, :death_date => nil, :death_hebrew_date_day => 16, :death_hebrew_date_month => 5, :death_hebrew_date_year => nil)
      person.death_hebrew_date.should be_nil
    end
  end
  
  describe "yahrzeit date (without year)" do
    let(:person) do
      person = FactoryGirl.build(:person, :death_date => nil, :death_hebrew_date_day => 16, :death_hebrew_date_month => 5, :death_hebrew_date_year => nil)
      person.should be_valid
      person.save
      person.reload
    end
    
    it "lets you save month day without year" do
      person.death_hebrew_date_day.should == 16
      person.death_hebrew_date_month.should == 5
      person.death_hebrew_date_year.should be_nil
    end
    it "return death_hebrew_date as nil" do
      person.death_hebrew_date.should be_nil
    end
    it "leaves western death date blank" do
      person.death_date.should be_nil
    end
  end
  
  describe "next_yahrzeit_date" do
    it "calculates yahrzeit within the next year" do
      person = FactoryGirl.create(:person, :death_date => "2000/08/17")
      Date.stub(:today).and_return(Date.parse("2011/11/6"))
      person.next_yahrzeit_date.should == Date.parse("2012/8/4")
    end
    it "calculates yahrzeit from a date" do
      person = FactoryGirl.create(:person, :death_date => "2000/08/17")
      from = Date.parse("2010/11/6")
      person.next_yahrzeit_date(from).should == Date.parse("2011/8/16")
    end
    it "calculates given yahrzeit date (without year)" do
      person = FactoryGirl.create(:person, death_date: nil, death_hebrew_date_month: 5, death_hebrew_date_day: 16, death_hebrew_date_year: nil)
      Date.stub(:today).and_return(Date.parse("2011/11/6"))
      person.next_yahrzeit_date.should == Date.parse("2012/8/4")
    end
  end
end
