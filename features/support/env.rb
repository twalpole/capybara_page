# frozen_string_literal: true

require 'capybara/dsl'
require 'capybara/cucumber'
require 'selenium-webdriver'

$LOAD_PATH << './test_site'
$LOAD_PATH << './lib'

require 'capybara_page'
require 'test_site'
require 'sections/people'
require 'sections/no_element_within_section'
require 'sections/container_with_element'
require 'sections/child'
require 'sections/parent'
require 'sections/search_result'
require 'pages/my_iframe'
require 'pages/home'
require 'pages/home_with_expected_elements'
require 'pages/dynamic_page'
require 'pages/no_title'
require 'pages/page_with_people'
require 'pages/redirect'
require 'pages/section_experiments'

Capybara.configure do |config|
  config.default_driver = :selenium
  config.javascript_driver = :selenium
  config.default_max_wait_time = 5
  config.app_host = 'file://' + File.dirname(__FILE__) + '/../../test_site/html'
end

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: browser)
end

private

def browser
  @browser ||= ENV.fetch('browser', 'firefox').to_sym
end
