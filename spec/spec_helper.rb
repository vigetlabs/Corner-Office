# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

if ENV['COV']
  require 'simplecov'
  SimpleCov.start 'rails'
end

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/poltergeist'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
  config.include FactoryGirl::Syntax::Methods
  config.include UserLoginController, :type => :controller
  config.include UserLoginFeature, :type => :feature

  config.before(:all, :js => :true) do
    self.use_transactional_fixtures = false
  end

  config.after(:all, :js => :true) do
    ActiveRecord::Base.transaction do
      ActiveRecord::Base.connection.tables.each do |t|
        ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{t} CASCADE")
      end
    end
  end

  config.before(:each, :js => :true) do
    Capybara.current_driver = :poltergeist
  end

  config.after(:each, :js => :true) do
    Capybara.use_default_driver
  end
end

VCR.configure do |c|
  c.ignore_hosts '127.0.0.1', 'localhost'
  c.hook_into :webmock
  c.cassette_library_dir = 'spec/fixtures/cassettes'
end
