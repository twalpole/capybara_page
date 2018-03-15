# frozen_string_literal: true

require 'spec_helper'

describe CapybaraPage::Page do
  it 'should respond to element' do
    expect(CapybaraPage::Page).to respond_to :element
  end

  it 'element method should generate existence check method' do
    class PageWithElement < CapybaraPage::Page
      element :bob, 'a.b c.d'
    end
    page = PageWithElement.new
    expect(page).to respond_to :has_bob?
  end

  it 'element method should generate method to return the element' do
    class PageWithElement < CapybaraPage::Page
      element :bob, 'a.b c.d'
    end
    page = PageWithElement.new
    expect(page).to respond_to :bob
  end

  it 'element method without css should generate existence check method' do
    class PageWithElement < CapybaraPage::Page
      element :thing, 'input#nonexistent'
    end
    page = PageWithElement.new
    expect(page).to respond_to :has_no_thing?
  end

  it 'should be able to wait for an element' do
    class PageWithElement < CapybaraPage::Page
      element :some_slow_element, 'a.slow'
    end
    page = PageWithElement.new
    expect(page).to respond_to :wait_for_some_slow_element
  end

  it 'should know if all mapped elements are on the page' do
    class PageWithAFewElements < CapybaraPage::Page
      element :bob, 'a.b c.d'
    end
    page = PageWithAFewElements.new
    expect(page).to respond_to :all_there?
  end

  describe '#expected_elements' do
    class PageWithAFewElements < CapybaraPage::Page
      element :bob, 'a.b c.d'
      element :success_msg, 'span.alert-success'

      expected_elements :bob
    end

    let(:page) { PageWithAFewElements.new }

    before do
      allow(page).to receive(:has_bob?).and_return(true)
      allow(page).to receive(:has_success_msg?).and_return(false)
    end

    it 'allows for a successful all_there? check' do
      expect(page.all_there?).to be_truthy
    end

    it 'checks only the expected elements' do
      page.all_there?
      expect(page).to have_received(:has_bob?).at_least(:once)
      expect(page).to_not have_received(:has_success_msg?)
    end
  end

  it 'element method with xpath should generate existence check method' do
    class PageWithElement < CapybaraPage::Page
      element :bob, :xpath, './/a[@class="b"]//c[@class="d"]'
    end
    page = PageWithElement.new
    expect(page).to respond_to :has_bob?
  end

  it 'element method with xpath should generate method to return the element' do
    class PageWithElement < CapybaraPage::Page
      element :bob, :xpath, './/a[@class="b"]//c[@class="d"]'
    end
    page = PageWithElement.new
    expect(page).to respond_to :bob
  end

  it 'should be able to wait for an element defined with xpath selector' do
    class PageWithElement < CapybaraPage::Page
      element :some_slow_element, :xpath, './/a[@class="slow"]'
    end
    page = PageWithElement.new
    expect(page).to respond_to :wait_for_some_slow_element
  end

  it 'should know if all mapped elements defined by xpath selector are on the page' do
    class PageWithAFewElements < CapybaraPage::Page
      element :bob, :xpath, './/a[@class="b"]//c[@class="d"]'
    end
    page = PageWithAFewElements.new
    expect(page).to respond_to :all_there?
  end
end
