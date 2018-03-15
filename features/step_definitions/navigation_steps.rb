# frozen_string_literal: true

When(/^I navigate to the home page$/) do
  @test_site = TestSite.new
  @test_site.home.load
end

When(/^I navigate to the home page that contains expected elements$/) do
  @test_site = TestSite.new
  @test_site.home_with_expected_elements.load
end

When(/^I navigate to the letter A page$/) do
  @test_site = TestSite.new
  @test_site.dynamic_page.load(letter: 'a')
end

When(/^I navigate to the redirect page$/) do
  @test_site = TestSite.new
  @test_site.redirect_page.load
end

Then(/^I am on the home page$/) do
  expect(@test_site.home).to be_displayed
end

Then(/^I am on a dynamic page$/) do
  expect(@test_site.dynamic_page).to be_displayed
end

Then(/^I am on the redirect page$/) do
  expect(@test_site.redirect_page).to be_displayed
end

Then(/^I am not on the redirect page$/) do
  expect(@test_site.redirect_page).to_not be_displayed
end

Then(/^I will be redirected to the home page$/) do
  expect(@test_site.home).to be_displayed
end

When(/^I navigate to a page with no title$/) do
  @test_site = TestSite.new
  @test_site.no_title.load
end

When(/^I navigate to another page$/) do
  @test_site.page_with_people.load
end

When(/^I navigate to the section experiments page$/) do
  @test_site = TestSite.new
  @test_site.section_experiments.load
end
