require 'spec_helper'

describe "people/index" do
  before(:each) do
    assign(:people, [
      stub_model(Person,
        :last_name => "Last Name",
        :first_name => "First Name",
        :middle_name => "Middle Name",
        :maiden => "Maiden",
        :prefix => "Prefix",
        :suffix => "Suffix",
        :gender => "Gender",
        :death_hebrew_date_day => 1,
        :death_hebrew_date_month => 2,
        :death_hebrew_date_year => 3,
        :death_after_sunset => false
      ),
      stub_model(Person,
        :last_name => "Last Name",
        :first_name => "First Name",
        :middle_name => "Middle Name",
        :maiden => "Maiden",
        :prefix => "Prefix",
        :suffix => "Suffix",
        :gender => "Gender",
        :death_hebrew_date_day => 1,
        :death_hebrew_date_month => 2,
        :death_hebrew_date_year => 3,
        :death_after_sunset => false
      )
    ])
  end

  it "renders a list of people" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Middle Name".to_s, :count => 2
    assert_select "tr>td", :text => "Maiden".to_s, :count => 2
    assert_select "tr>td", :text => "Prefix".to_s, :count => 2
    assert_select "tr>td", :text => "Suffix".to_s, :count => 2
    assert_select "tr>td", :text => "Gender".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
