# frozen_string_literal: true

require 'spec_helper'

describe 'Page Navigation' do
  around :context do |example|
    Capybara.using_driver(:selenium) do
      example.run
    end
  end

  before { @test_site = TestSite.new }

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
end
