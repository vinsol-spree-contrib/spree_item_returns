# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_item_returns'
  s.version     = '3.4.0'
  s.summary     = 'Spree Item Returns'
  s.description = '
                    At User-End
                    - User can Initate items-return process
                    - Can check return history
                  '
  s.required_ruby_version = '>= 2.5.0'

  s.author    = 'Anurag Bhardwaj'
  s.email     = 'info@vinsol.com'
  s.homepage  = 'http://vinsol.com'
  s.license   = 'BSD-3'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '>= 4.0.0'
  s.add_dependency 'spree_extension', '~> 0.0.9'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'capybara', '>= 3.30.0'
  s.add_development_dependency 'coffee-rails', '~> 5.0.0'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_bot'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rails-controller-testing', '~> 1.0.4'
  s.add_development_dependency 'rspec-activemodel-mocks', '~> 1.1.0'
  s.add_development_dependency 'rspec-rails', '~> 4.0.0'
  s.add_development_dependency 'sass-rails', '>= 5.0.0'
  s.add_development_dependency 'selenium-webdriver', '~> 3.0.8'
  s.add_development_dependency 'shoulda-matchers', '~> 4.3'
  s.add_development_dependency 'shoulda-callback-matchers', '~> 1.1.1'
  s.add_development_dependency 'simplecov', '~> 0.18.0'
  s.add_development_dependency 'sqlite3', '~> 1.4'

end
