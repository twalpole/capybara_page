# frozen_string_literal: true

class TestHomePage < CapybaraPage::Page
  set_url '/home.htm'
  set_url_matcher(/home\.htm$/)

  # individual elements
  element :welcome_header, :xpath, './/body/h1'
  element :welcome_message, :css, 'span.welcome'
  element :go_button, :button, 'Go!'
  element :link_to_search_page, :link, 'Search Page'
  element :some_slow_element, :xpath, './/a[@class="slow"]'
  element :invisible_element, 'input.invisible'
  element :shy_element, 'input#will_become_visible'
  element :retiring_element, 'input#will_become_invisible'
  element :removing_element, 'input#will_become_nonexistent'
  element :remove_container_with_element_btn, 'input#remove_container_with_element'

  # elements groups
  elements :lots_of_links, :xpath, './/td//a'
  elements :nonexistent_elements, 'input#nonexistent'
  elements :removing_links, '#link_container_will_become_nonexistent > a'
  elements :welcome_headers, :css, 'h3'
  elements :welcome_messages, :xpath, './/span'
  elements :rows, 'td'

  # elements that should not exist
  element :squirrel, 'squirrel.nutz'
  element :other_thingy, 'other.thingy'
  element :nonexistent_element, 'input#nonexistent'

  # Individual sections
  section :people, People, '.people' do
    element :headline_clone, 'h2'
  end
  section :container_with_element, ContainerWithElement, '#container_with_element'
  section :nonexistent_section, NoElementWithinSection, 'input#nonexistent'
  section :removing_section, NoElementWithinSection, 'input#will_become_nonexistent'

  # section groups
  sections :nonexistent_sections, NoElementWithinSection, 'input#nonexistent'
  sections :removing_sections, NoElementWithinSection, '#link_container_will_become_nonexistent > a'

  # iframes
  iframe :my_iframe, MyIframe, '#the_iframe'
  iframe :index_iframe, MyIframe, 0
  iframe :named_iframe, MyIframe, '[name="the_iframe"]'
  iframe :xpath_iframe, MyIframe, :xpath, './/iframe[@name="the_iframe"]'
end
