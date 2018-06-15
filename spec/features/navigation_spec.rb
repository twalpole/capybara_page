# frozen_string_literal: true

require 'spec_helper'

feature 'Page Navigation' do
  it "goes to a static page" do
    @test_site.home.load
    expect(@test_site.home).to be_displayed
  end

  it "goes to a dynamic page" do
    @test_site.dynamic_page.load(letter: 'a')
    expect(@test_site.dynamic_page).to be_displayed
  end

  it "waits to be redirected" do
    @test_site.redirect_page.load
    expect(@test_site.redirect_page).to be_displayed
    expect(@test_site.home).to be_displayed
  end

  it "knows which page it's on" do
    @test_site.home.load
    expect(@test_site.redirect_page).not_to be_displayed
  end

  it "navigates to a different page" do
    @test_site.home.load
    @test_site.home.go_button.click
    expect(@test_site.no_title).to be_displayed
  end
end
