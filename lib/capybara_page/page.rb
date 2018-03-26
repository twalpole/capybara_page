# frozen_string_literal: true

require 'capybara_page/loadable'

module CapybaraPage
  class Page
    include ElementChecker
    include Loadable
    extend Forwardable
    extend ElementContainer

    # def_delegators :page,  *Capybara::Session::SESSION_METHODS
    def_delegators :page, :visit, :current_url, :text, :html, :title

    load_validation do
      [displayed?, "Expected #{current_url} to match #{url_matcher} but it did not."]
    end

    def page
      @page || Capybara.current_session
    end

    def root_element
      page.document
    end

    def to_capybara_node
      root_element
    end

    def session
      root_element.session
    end

    # Loads the page.
    # @param expansion_or_html
    # @param block [&block] An optional block to run once the page is loaded.
    # The page will yield the block if defined.
    #
    # Executes the block, if given.
    # Runs load validations on the page, unless input is a string
    def load(expansion_or_html = {}, &block)
      self.loaded = false

      if expansion_or_html.is_a?(String)
        @page = Capybara.string(expansion_or_html)
        yield self if block_given?
      else
        expanded_url = url(expansion_or_html)
        raise CapybaraPage::NoUrlForPage if expanded_url.nil?
        visit expanded_url
        when_loaded(&block) if block_given?
      end
    end

    def displayed?(*args)
      expected_mappings = args.last.is_a?(::Hash) ? args.pop : {}
      seconds = args.first
      seconds = root_element.session_options.default_max_wait_time if seconds.nil?
      raise CapybaraPage::NoUrlMatcherForPage if url_matcher.nil?

      start_time = Time.now
      loop do
        return true if url_matches?(expected_mappings)
        break unless Time.now - start_time <= seconds
        sleep(0.05)
      end
      false
    end

    def url_matches(seconds = nil)
      return unless displayed?(seconds)

      if url_matcher.is_a?(Regexp)
        regexp_backed_matches
      else
        template_backed_matches
      end
    end

    def regexp_backed_matches
      url_matcher.match(page.current_url)
    end

    def template_backed_matches
      matcher_template.mappings(page.current_url)
    end

    def self.set_url(page_url)
      @url = page_url.to_s
    end

    def self.set_url_matcher(page_url_matcher)
      @url_matcher = page_url_matcher
    end

    class << self
      attr_reader :url
    end

    def self.url_matcher
      @url_matcher || url
    end

    def url(expansion = {})
      return nil if self.class.url.nil?
      Addressable::Template.new(self.class.url).expand(expansion).to_s
    end

    def url_matcher
      self.class.url_matcher
    end

    def secure?
      page.current_url.start_with? 'https'
    end

  private

    def find(*find_args)
      page.find(*find_args)
    end

    def find_all(*find_args)
      page.all(*find_args)
    end

    def element_exists?(*find_args)
      page.has_selector?(*find_args)
    end

    def element_does_not_exist?(*find_args)
      page.has_no_selector?(*find_args)
    end

    def url_matches?(expected_mappings = {})
      if url_matcher.is_a?(Regexp)
        url_matches_by_regexp?
      elsif url_matcher.respond_to?(:to_str)
        url_matches_by_template?(expected_mappings)
      else
        raise CapybaraPage::InvalidUrlMatcher
      end
    end

    def url_matches_by_regexp?
      !regexp_backed_matches.nil?
    end

    def url_matches_by_template?(expected_mappings)
      matcher_template.matches?(page.current_url, expected_mappings)
    end

    def matcher_template
      @matcher_template ||= AddressableUrlMatcher.new(url_matcher)
    end
  end
end
