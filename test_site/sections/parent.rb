# frozen_string_literal: true

class Parent < CapybaraPage::Section
  element :slow_section_element, 'a.slow'
  section :child_section, Child, '.child-div'
end
