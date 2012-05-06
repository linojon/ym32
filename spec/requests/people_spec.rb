require 'spec_helper'

describe "People" do
  before :each do
    create_and_login_user
  end
  
  #------------------------
  describe "GET /people" do
    let!(:person1) { FactoryGirl.create(:person, last_name: 'Linowitz', first_name: 'Bbbb', death_date: '2011-Mar-15') }
    let!(:person2) { FactoryGirl.create(:person, last_name: 'Linowitz', first_name: 'Aaaa', death_date: '2010-Feb-1') }
    let!(:person3) { FactoryGirl.create(:person, last_name: 'Cohen', death_date: '2011-May-1') }
    
    it "shows list of yahrzeits" do
      visit '/people'
      page.should have_selector("table#people")
      page.should have_content(person1.last_name)
      page.should have_content(person2.last_name)
    end
    
    #it "sorts by last name, first name by default"
    
    it "sorts by last name, first name" do
      # should be 3 2 1
      visit '/people?sort=last_name,first_name'
      page.all("table#people tbody tr")[0].should have_content('Cohen')
      
      page.all("table#people tbody tr")[1].should have_content('Linowitz')
      page.all("table#people tbody tr")[1].should have_content('Aaaa')
      
      page.all("table#people tbody tr")[2].should have_content('Linowitz')
      page.all("table#people tbody tr")[2].should have_content('Bbbb')
    end

    it "sorts by death date" do
      # should be 2 1 3
      visit '/people?sort=death_date'
      page.all("table#people tbody tr")[0].should have_content('Aaaa')
      page.all("table#people tbody tr")[1].should have_content('Bbbb')
      page.all("table#people tbody tr")[2].should have_content('Cohen')
    end

    it "sorts by yahrzeit" do
      # should be 3 2 1
      visit '/people?sort=death_hebrew_date_month,death_hebrew_date_day'
      page.all("table#people tbody tr")[0].should have_content('Cohen')
      
      page.all("table#people tbody tr")[1].should have_content('Linowitz')
      page.all("table#people tbody tr")[1].should have_content('Aaaa')
      
      page.all("table#people tbody tr")[2].should have_content('Linowitz')
      page.all("table#people tbody tr")[2].should have_content('Bbbb')
    end
    
    it "sorts by next yahrzeit date" do
      Date.stub(:today) { Date.parse("2012-Apr-1")}
      # should be 1 3 2     
      visit '/people?sort=next_yahrzeit_date'
      page.all("table#people tbody tr")[0].should have_content('Bbbb')
      page.all("table#people tbody tr")[1].should have_content('Cohen')
      page.all("table#people tbody tr")[2].should have_content('Aaaa')
    end
    
    # describe "paginate" do
    #   before :each do
    #     15.times { FactoryGirl.create(:person) }
    #   end
    #   it "10 items per page" do
    #     visit '/people'
    #     save_and_open_page
    #     page.should have_selector('table#people tbody tr', :count => 10)
    #   end
    #   it "less items on last page" do
    #     visit '/people?page=2'
    #     page.should have_selector("table#people tbody tr", :count => 7)
    #   end
    # end
  end
  
  #------------------------
  describe "GET /people/new" do
    it "has select list of name prefix" do
      visit '/people/new'
      %w{ Ms Miss Mrs Mr Dr Atty Prof Hon Gov Ofc }.each do |prefix|
        select(prefix, :from => 'Prefix')
      end
    end
    
    it "has select list of genders" do
      visit '/people/new'
      select('male', :from => 'Gender')
      select('female', :from => 'Gender')
    end
    
    it "allows birth year from today back to 200 years ago" do
      visit '/people/new'
      select_year('Birth date', :with => Time.now.year)
      select_year('Birth date', :with => Time.now.year-200)
    end
    
    it "allows death year back to 200 years ago" do
      visit '/people/new'
      select_year('Death date', :with => Time.now.year)
      select_year('Death date', :with => Time.now.year-200)
    end
    
    it "allows hebrew death date" do
      visit '/people/new'
      select(:person_death_hebrew_date_day, :with => 16)
      select(:person_death_hebrew_date_month, :with => 'Av')
      select(:person_death_hebrew_date_year, :with => 5760)
    end
  end
  
  #------------------------
  describe "PUT /people/create" do
    before :each do
      visit '/people/new'
    end
    
    it "allows blank dates" do
      fill_in 'First name', :with => 'Josh'
      fill_in 'Last name', :with => 'Cohen'
      click_button 'Create Person'
      person = Person.last
      person.birth_date.should be_blank
      person.death_date.should be_blank
    end
  
    describe "shows validation error" do
      it "when missing first name" do
        click_button 'Create Person'
        #save_and_open_page
        within("div.alert-error") do
          page.should have_content("Person could not be saved. Please check your input.")
        end
        within_input_for "First name" do
         page.should have_content("can't be blank")
        end 
      end
    
      it "when missing last name" do
        click_button 'Create Person'
        within("div.alert-error") do
          page.should have_content("Person could not be saved. Please check your input.")
        end
        within_input_for "Last name" do
         page.should have_content("can't be blank")
        end 
      end
    
      it "when last name is only one char" do
        fill_in 'Last name', :with => 'c'
        click_button 'Create Person'
        within("div.alert-error") do
          page.should have_content("Person could not be saved. Please check your input.")
        end
        within_input_for "Last name" do
         page.should have_content("is too short (minimum is 2 characters)")
        end 
      end
      
     it "when names are not properly formed" do
       # not going to check everything, the proper_name validation is a unit test
       fill_in "Last name", :with => 'Ab2c'
       click_button 'Create Person'
       within("div.alert-error") do
         page.should have_content("Person could not be saved. Please check your input.")
       end
       within_input_for "Last name" do
        page.should have_content("is not a proper name format")
       end 
      end
      
      it "when death date is before birth date" do
        fill_in 'First name', :with => 'Josh'
        fill_in 'Last name', :with => 'Cohen'
        select_date 'Birth date', :with => '1960-1-1'
        select_date 'Death date', :with => '1959-1-1'
        click_button 'Create Person'
        within("div.alert-error") do
          page.should have_content("Person could not be saved. Please check your input.")
        end
        within_input_for "Death date" do
         page.should have_content("can't be before birth date")
        end 
      end
    end
    
    # JAVASCRIPT VALIDATIONS
    # describe "shows client side validations", :js => true do
    #   def fill_in(field, value)
    #     super
    #     trigger_blur_event field if Capybara.current_driver == :selenium  
    #   end
    # 
    #   it "when missing first name" do
    #     fill_in 'First name', :with => ''
    #     within_input_for "First name" do
    #      page.should have_content("can't be blank")
    #     end 
    #   end
    # 
    #   it "when missing last name" do
    #     fill_in 'Last name', :with => ''
    #     within_input_for "Last name" do
    #      page.should have_content("can't be blank")
    #     end 
    #   end
    # 
    #   it "when last name is only one char" do
    #     fill_in 'Last name', :with => 'c'
    #     within_input_for "Last name" do
    #      page.should have_content("is too short (minimum is 2 characters)")
    #     end 
    #   end
    #   
    #   it "when names are not properly formed - numerics" do
    #     # TODO: unit test the javascript validator as thoroughly as the ruby one
    #     fill_in "Last name", :with => 'Ab2c'
    #     within_input_for "Last name" do
    #      page.should have_content("is not a proper name format")
    #     end 
    #   end
    #   it "when names are not properly formed - nonnumerics" do
    #     fill_in "Last name", :with => 'Ab+c'
    #     within_input_for "Last name" do
    #      page.should have_content("is not a proper name format")
    #     end 
    #   end
    #   it "not fail on leading/trailing spaces" do
    #     fill_in "Last name", :with => ' abc '
    #     within_input_for "Last name" do
    #      page.should_not have_content("is not a proper name format")
    #     end 
    #   end
    #   
    # end

    describe "death hebrew date" do
      it "can set from form" do
        fill_in 'First name', :with => 'Josh'
        fill_in 'Last name', :with => 'Cohen'
        select '16', :from => 'person_death_hebrew_date_day'
        select 'Av', :from => 'person_death_hebrew_date_month'
        select '5760', :from => 'person_death_hebrew_date_year'
        click_button 'Create Person'
        current_path.should == '/people'
        page.should have_content("Av 16")
      end
    end
  end
  
  #------------------------
  describe "POST /people/1/update" do
    let!(:person) { FactoryGirl.create(:person, :death_hebrew_date_day => 16, :death_hebrew_date_month => 'Av', :death_hebrew_date_year => 5760) }
    before :each do
      visit "/people/#{person.id}/edit"
    end
    describe "death hebrew date" do
      it "can set from form" do
        select '17', :from => 'person_death_hebrew_date_day'
        select 'Elul', :from => 'person_death_hebrew_date_month'
        select '5761', :from => 'person_death_hebrew_date_year'
        click_button 'Update Person'
        current_path.should == '/people'
        page.should have_content("Elul 17")
      end
    end
  end
end
