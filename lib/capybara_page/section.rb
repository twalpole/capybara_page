# frozen_string_literal: true

require 'capybara_page/loadable'

module CapybaraPage
  class Section
    include ElementChecker
    include Loadable
    extend ElementContainer

    attr_reader :root_element, :parent

    def self.set_default_search_arguments(*args)
      @default_search_arguments = args
    end

    def self.default_search_arguments
      @default_search_arguments ||
        (
          superclass.respond_to?(:default_search_arguments) &&
          superclass.default_search_arguments
        ) ||
        nil
    end

    def initialize(parent, root_element)
      raise ArgumentError, "You must pass the root_element to a section" unless root_element
      @parent = parent
      @root_element = root_element
      Capybara.within(@root_element) { yield(self) } if block_given?
    end

    def page
      root_element
    end

    def visible?
      page.visible?
    end

    def execute_script(input)
      page.execute_script(input)
    end

    def evaluate_script(input)
      page.evaluate_script(input)
    end

    def text
      root_element.text
    end

    def session
      root_element.session
    end

    def parent_page
      candidate_page = parent
      until candidate_page.is_a?(CapybaraPage::Page)
        candidate_page = candidate_page.parent
      end
      candidate_page
    end

    def native
      root_element.native
    end

    def to_capybara_node
      root_element
    end

  private

    %w[find find_all].each do |method|
      define_method(method) { |*args| root_element.send(method, *args) }
    end

    def element_exists?(*find_args)
      root_element&.has_selector?(*find_args)
    end

    def element_does_not_exist?(*find_args)
      root_element&.has_no_selector?(*find_args)
    end
  end
end
