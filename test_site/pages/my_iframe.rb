# frozen_string_literal: true

class MyIframe < CapybaraPage::Page
  element :some_text, 'span#some_text_in_an_iframe'
end
