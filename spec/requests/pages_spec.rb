require 'spec_helper'

describe "Pages", :type => :request do
  describe "GET /" do
    it "is on the home page" do
      visit '/'
      current_path.should == '/'
    end
  end
  describe "GET /about" do
    it "is on the About page" do
      visit '/about'
      current_path.should == '/about'
    end
  end
end
