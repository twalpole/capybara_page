# frozen_string_literal: true

module CapybaraPage
  module ElementChecker
    def all_there?
      elements_to_check.all? { |element| send "has_#{element}?" }
    end

  private

    def elements_to_check
      elements = self.class.mapped_items
      elements &= self.class.expected_items if self.class.expected_items
      elements
    end
  end
end
