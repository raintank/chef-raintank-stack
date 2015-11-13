require 'rubygems'

require 'capybara'
require 'capybara/rspec'
require 'headless'
require 'capybara/webkit'

Capybara.configure do |config|
  config.run_server = false
  config.app_host = "http://localhost:3000"
  config.javascript_driver = :webkit
  config.current_driver = config.javascript_driver
end
Capybara.default_driver = :webkit

RSpec.configure do |config|
  config.include Capybara::DSL
end

headless = Headless.new
headless.start
at_exit { headless.stop } 
