# frozen_string_literal: true

require 'spec_helper'

feature 'Waiting for elements' do
  it "waits for element to appear" do
    home = @test_site.home
    home.load
    expect(home.some_slow_element).to be
  end

  it "can specify the wait time for an element" do
    home = @test_site.home
    home.load
    expect { home.some_slow_element(wait: 1) }.to raise_error Capybara::ElementNotFound
  end

  it "can specify a time with wait_for_xxx method" do
    @test_site.home.load
    expect { @test_site.home.wait_for_some_slow_element(1) }.to raise_error CapybaraPage::TimeOutWaitingForExistenceError
  end

  it "waits for element to disappear" do
    @test_site.home.load
    @test_site.home.wait_for_no_removing_element
    expect(@test_site.home).not_to have_removing_element
  end

  it "raises exception if element doesn't disappear" do
    @test_site.home.load
    expect { @test_site.home.wait_for_no_removing_element(1) }.to raise_error CapybaraPage::TimeOutWaitingForNonExistenceError
  end

  it "waits for visibility" do
    @test_site.home.load
    @test_site.home.wait_until_some_slow_element_visible
    expect(@test_site.home.some_slow_element(wait: 0, visible: true)).to be
  end

  # Scenario: Wait for Visibility of element - Overridden Timeout
  #   When I navigate to the home page
  #   And I wait for a specific amount of time until a particular element is visible
  #   Then the previously invisible element is visible
  #
  # Scenario: Wait for Visibility of element - Negative Test
  #   When I navigate to the home page
  #   Then I get a timeout error when I wait for an element that never appears
  #
  # Scenario: Wait for Invisibility of element - Default Timeout
  #   When I navigate to the home page
  #   And I wait for an element to become invisible
  #   Then the previously visible element is invisible
  #
  # Scenario: Wait for Invisibility of element - Overriden Timeout
  #   When I navigate to the home page
  #   And I wait for a specific amount of time until a particular element is invisible
  #   Then the previously visible element is invisible
  #
  # Scenario: Wait for Invisibility of element - Negative Test
  #   When I navigate to the home page
  #   Then I get a timeout error when I wait for an element that never disappears
  #
  # Scenario: Wait for Invisibility of element - Non-Existent Element
  #   When I navigate to the home page
  #   Then I do not wait for an nonexistent element when checking for invisibility
  #
  # Scenario: Wait for Invisibility of element - Non-Existent Section
  #   When I navigate to the home page
  #   And I remove the parent section of the element
  #   Then I receive an error when a section with the element I am waiting for is removed

end
