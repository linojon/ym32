# for request specs using Capybara
def login(user)
  visit login_path
  fill_in 'Email', with: user.email
  fill_in 'Password', with: 'secret'
  click_button 'Log In'
end

def create_and_login_user
  login FactoryGirl.create(:user)
end

  