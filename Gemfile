source 'https://rubygems.org'

gem 'rails', '3.2.2'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'haml-rails'
gem 'simple_form'

# official unofficial ruby-debug19 fix
# with the same gems as mentioned in 
# https://gist.github.com/1333785
source 'https://gems.gemfury.com/8n1rdTK8pezvcsyVmmgJ/' 
group :test, :development do
  gem 'linecache19',       '>= 0.5.13'
  gem 'ruby-debug-base19', '>= 0.11.26'
  gem 'ruby-debug19'
  gem 'sqlite3'
end

group :test, :development do
  #gem 'ruby-debug19', :require => 'ruby-debug'
  gem "rspec-rails"
  gem 'rspec-instafail'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem "capybara"
end

gem 'heroku'

group :production do
  gem 'thin'
  gem 'pg'
end



# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
