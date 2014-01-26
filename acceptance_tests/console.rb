require 'capybara'
require 'capybara/rspec'
require './shared'
require './seed'

Capybara.app_host = 'http://localhost:3000'
Capybara.run_server = false
Capybara.default_driver = :selenium
Capybara.default_selector = :css

include Capybara::DSL
include Features::Shared