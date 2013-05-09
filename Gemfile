source 'https://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'bootstrap-sass', '~> 2.3.1.0'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

gem "airbrake"
gem "simplest_auth"
gem "simple_form"
gem "oauth2"
gem "highrise"

group :assets do
  gem "compass-rails"
end

group :test, :development do
  gem "pry"
  gem "rspec-rails"
  gem "factory_girl_rails"
  gem "simplecov", :require => false
  gem "awesome_print"
  gem "pry-remote"
end

group :development do
  gem "rails-dev-tweaks"
  gem "quiet_assets"
  gem "viget-deployment", :git => "git@github.com:vigetlabs/viget-deployment.git", :require => false
end

group :test do
  gem "capybara"
  gem "shoulda-matchers"
  gem "factory_girl"
  gem "launchy", :require => false
  gem "vcr"
  gem "webmock"
  gem "poltergeist"
end

gem "nokogiri"
group :development do
  gem "capistrano"
  gem "capistrano-ext"
end
