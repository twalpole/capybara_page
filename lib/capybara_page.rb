# frozen_string_literal: true

require 'capybara_page/exceptions'
require 'addressable/template'

module CapybaraPage
  autoload :ElementContainer, 'capybara_page/element_container'
  autoload :ElementChecker, 'capybara_page/element_checker'
  autoload :Page, 'capybara_page/page'
  autoload :Section, 'capybara_page/section'
  autoload :AddressableUrlMatcher, 'capybara_page/addressable_url_matcher'
end
