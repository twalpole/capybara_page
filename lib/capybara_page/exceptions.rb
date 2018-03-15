# frozen_string_literal: true

module CapybaraPage
  class NoUrlForPage < StandardError; end
  class NoUrlMatcherForPage < StandardError; end

  class InvalidUrlMatcher < StandardError
    def message
      'Could not automatically match your URL. Templated port numbers are unsupported.'
    end
  end

  class NoSelectorForElement < StandardError; end
  class TimeoutException < StandardError; end
  class TimeOutWaitingForElementVisibility < StandardError; end
  class TimeOutWaitingForElementInvisibility < StandardError; end

  class UnsupportedBlock < StandardError
    def message
      "#{super} does not accept blocks, did you mean to define a (i)frame?"
    end
  end

  NotLoadedError = Class.new(StandardError)
end
