# frozen_string_literal: true

require 'spec_helper'

feature 'Malformed Items' do
  it "Element without selector" do
    no_title = @test_site.no_title.load
    expect { no_title.has_element_without_selector? }
      .to raise_error(CapybaraPage::NoSelectorForElement)
    expect { no_title.element_without_selector }
      .to raise_error(CapybaraPage::NoSelectorForElement)
    expect { no_title.wait_for_element_without_selector }
      .to raise_error(CapybaraPage::NoSelectorForElement)
  end

  it "Elements without selector" do
    no_title = @test_site.no_title.load
    expect { no_title.has_elements_without_selector? }
      .to raise_error(CapybaraPage::NoSelectorForElement)
    expect { no_title.elements_without_selector }
      .to raise_error(CapybaraPage::NoSelectorForElement)
    expect { no_title.wait_for_elements_without_selector }
      .to raise_error(CapybaraPage::NoSelectorForElement)
  end
end
