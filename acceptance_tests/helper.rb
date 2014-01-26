require 'capybara'
require 'capybara/rspec'

require './shared'
require './seed'

RSpec.configure do |config|
  config.include Capybara::DSL, type: :feature
  config.include Features::Shared, type: :feature
end

Capybara.app_host = 'http://localhost:3000'
Capybara.run_server = false

Capybara.default_driver = :selenium
Capybara.default_selector = :css

