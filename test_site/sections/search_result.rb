# frozen_string_literal: true

class SearchResult < CapybaraPage::Section
  element :title, 'span.title'
  element :link, 'a'
  element :description, 'span.description'
end
