# frozen_string_literal: true

require './lib/capybara_page/version'

Gem::Specification.new do |s|
  s.name        = 'capybara_page'
  s.version     = CapybaraPage::VERSION
  s.required_ruby_version = '>= 2.5.0'
  s.platform    = Gem::Platform::RUBY
  s.license     = "MIT"
  s.authors     = ['Thomas Walpole']
  s.email       = %w[twalpole@gmail.com]
  s.homepage    = 'http://github.com/twalpole/capybara_page'
  s.summary     = 'A Page Object DSL for Capybara'
  s.description = 'CapybaraPage implements the Page Object Model pattern on top of Capybara.'
  s.files        = Dir.glob('lib/**/*') + %w[README.md]
  s.require_path = 'lib'
  s.add_dependency 'capybara', ['~>3.2']

  s.add_development_dependency 'byebug'
  s.add_development_dependency 'puma'
  s.add_development_dependency("rake")
  s.add_development_dependency 'rspec', ['~> 3.7']
  s.add_development_dependency("rubocop")
  s.add_development_dependency 'selenium-webdriver', ['~>3.7.0']
  s.add_development_dependency 'sinatra'
end
