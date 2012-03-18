require 'spec_helper'

describe "people/edit" do
  before(:each) do
    @person = assign(:person, stub_model(Person,
      :last_name => "MyString",
      :first_name => "MyString",
      :middle_name => "MyString",
      :maiden => "MyString",
      :prefix => "MyString",
      :suffix => "MyString",
      :gender => "MyString",
      :death_hebrew_date_day => 1,
      :death_hebrew_date_month => 1,
      :death_hebrew_date_year => 1,
      :death_after_sunset => false
    ))
  end

  it "renders the edit person form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => people_path(@person), :method => "post" do
      assert_select "input#person_last_name", :name => "person[last_name]"
      assert_select "input#person_first_name", :name => "person[first_name]"
      assert_select "input#person_middle_name", :name => "person[middle_name]"
      assert_select "input#person_maiden", :name => "person[maiden]"
      assert_select "input#person_prefix", :name => "person[prefix]"
      assert_select "input#person_suffix", :name => "person[suffix]"
      assert_select "input#person_gender", :name => "person[gender]"
      assert_select "input#person_death_hebrew_date_day", :name => "person[death_hebrew_date_day]"
      assert_select "input#person_death_hebrew_date_month", :name => "person[death_hebrew_date_month]"
      assert_select "input#person_death_hebrew_date_year", :name => "person[death_hebrew_date_year]"
      assert_select "input#person_death_after_sunset", :name => "person[death_after_sunset]"
    end
  end
end
