# frozen_string_literal: true

class TestNoTitle < CapybaraPage::Page
  set_url '/no_title.htm'

  element :element_without_selector
  elements :elements_without_selector
end
