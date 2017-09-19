# Run Coverage report
require 'simplecov'
SimpleCov.start 'rails'

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)

require 'rspec/rails'
require 'database_cleaner'
require 'ffaker'
require 'shoulda-matchers'
require 'rails-controller-testing'
require 'rspec-activemodel-mocks'
require 'shoulda-callback-matchers'
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/capybara_ext'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/factories'
require 'spree/testing_support/url_helpers'


# Requires factories defined in lib/spree_item_returns/factories.rb
require 'spree_item_returns/factories'

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

ActionMailer::Base.default_url_options[:host] ||= 'test.com'
ActiveJob::Base.queue_adapter = :test

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Spree::TestingSupport::UrlHelpers
  config.include Spree::TestingSupport::ControllerRequests, type: :controller

  config.mock_with :rspec
  config.color = true
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false

  config.fail_fast = ENV['FAIL_FAST'] || false
  config.order = "random"
end
