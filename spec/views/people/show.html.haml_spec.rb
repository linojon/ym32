require 'spec_helper'

describe "people/show" do
  before(:each) do
    @person = assign(:person, stub_model(Person,
      :last_name => "Last Name",
      :first_name => "First Name",
      :middle_name => "Middle Name",
      :maden => "Maden",
      :prefix => "Prefix",
      :suffix => "Suffix",
      :gender => "Gender",
      :death_hebrew_date_day => 1,
      :death_hebrew_date_month => 2,
      :death_hebrew_date_year => 3,
      :death_after_sunset => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Last Name/)
    rendered.should match(/First Name/)
    rendered.should match(/Middle Name/)
    rendered.should match(/Maden/)
    rendered.should match(/Prefix/)
    rendered.should match(/Suffix/)
    rendered.should match(/Gender/)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/false/)
  end
end
