require File.dirname(__FILE__) + '/../spec_helper'

describe PagesController do
  render_views

  it "home action should render home template" do
    get :home
    response.should render_template(:home)
  end

  it "about action should render about template" do
    get :about
    response.should render_template(:about)
  end
end
