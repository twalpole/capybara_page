# frozen_string_literal: true

require 'digest'
require 'base64'

module CapybaraPage
  class AddressableUrlMatcher
    COMPONENT_NAMES = %i[scheme user password host port path query fragment].freeze
    COMPONENT_PREFIXES = {
      query: '?',
      fragment: '#'
    }.freeze

    attr_reader :pattern

    def initialize(pattern)
      @pattern = pattern
    end

    # @return the hash of extracted mappings from parsing the provided URL according to our pattern,
    # or nil if the URL doesn't conform to the matcher template.
    def mappings(url)
      uri = Addressable::URI.parse(url)
      COMPONENT_NAMES.each_with_object({}) do |component, h|
        component_result = component_matches(component, uri)
        return nil unless component_result
        h.merge!(component_result)
      end

      # result = {}
      # COMPONENT_NAMES.each do |component|
      #   component_result = component_matches(component, uri)
      #   return nil unless component_result
      #
      #   result.merge!(component_result)
      # end
      # result
    end

    # Determine whether URL matches our pattern, and optionally whether the extracted mappings match
    # a hash of expected values.  You can specify values as strings, numbers or regular expressions.
    def matches?(url, expected_mappings = {})
      actual_mappings = mappings(url)
      return all_expected_mappings_match?(expected_mappings, actual_mappings) if actual_mappings
      false
    end

  private

    def all_expected_mappings_match?(expected_mappings, actual_mappings)
      expected_mappings.all? do |key, expected_value|
        actual_value = actual_mappings[key.to_s]
        case expected_value
        when Numeric
          actual_value == expected_value.to_s
        when Regexp
          actual_value.match(expected_value)
        else
          expected_value == actual_value
        end
      end
    end

    def component_templates
      @component_templates ||= extract_component_templates
    end

    def extract_component_templates
      COMPONENT_NAMES.each_with_object({}) do |component, component_templates|
        component_url = to_substituted_uri.public_send(component).to_s

        next unless component_url && !component_url.empty?
        # next if component_url.empty?

        reverse_substitutions.each_pair do |substituted_value, template_value|
          component_url = component_url.sub(substituted_value, template_value)
        end

        component_templates[component] = Addressable::Template.new(component_url.to_s)
      end
    end

    # Returns empty hash if the template omits the component, a set of substitutions if the
    # provided URI component matches the template component, or nil if the match fails.
    def component_matches(component, uri)
      extracted_mappings = {}
      component_template = component_templates[component]
      if component_template
        component_url = uri.public_send(component).to_s
        extracted_mappings = component_template.extract(component_url)
        unless extracted_mappings
          # to support Addressable's expansion of queries
          # ensure it's parsing the fragment as appropriate (e.g. {?params*})
          prefix = COMPONENT_PREFIXES[component]
          return nil unless prefix && (extracted_mappings = component_template.extract(prefix + component_url))
        end
      end
      extracted_mappings
    end

    # Convert the pattern into an Addressable URI by substituting the template slugs with nonsense strings.
    def to_substituted_uri
      url = pattern
      substitutions.each_pair { |slug, value| url = url.sub(slug, value) }
      Addressable::URI.parse(url)
    rescue Addressable::URI::InvalidURIError
      raise CapybaraPage::InvalidUrlMatcher
    end

    def substitutions
      @substitutions ||= slugs.each_with_index.reduce({}) do |memo, slug_index|
        slug, index = slug_index
        memo.merge(slug => slug_prefix(slug) + substitution_value(index))
      end
    end

    def reverse_substitutions
      @reverse_substitutions ||= slugs.each_with_index.reduce({}) do |memo, slug_index|
        slug, index = slug_index
        memo.merge(slug_prefix(slug) + substitution_value(index) => slug, substitution_value(index) => slug)
      end
    end

    def slugs
      pattern.scan(/{[^}]+}/)
    end

    # If a slug begins with non-alpha characters, it may denote the start of a new component
    # (e.g. query or fragment). We emit this prefix as part of the substituted slug
    # so that Addressable's URI parser can see it as such.
    def slug_prefix(slug)
      matches = slug.match(/\A{([^A-Za-z]+)/)
      matches && matches[1] || ''
    end

    # Generate a repeatable 5 character uniform alphabetical nonsense string
    # to allow parsing as a URI
    def substitution_value(index)
      Base64.urlsafe_encode64(Digest::SHA1.digest(index.to_s)).gsub(/[^A-Za-z]/, '')[0..5]
    end
  end
end
