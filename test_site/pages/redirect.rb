# frozen_string_literal: true

class RedirectPage < CapybaraPage::Page
  set_url '/redirect.htm'
  set_url_matcher(/redirect\.htm$/)
end
