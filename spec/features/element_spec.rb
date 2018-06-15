# frozen_string_literal: true

require 'spec_helper'

feature 'Element Methods' do
  it "can match text" do
    home = @test_site.home.load
    expect(home).to have_welcome_header
    expect(home.welcome_header.text).to eq('Welcome')
    expect(home).to have_welcome_headers(text: 'Sub-Heading 2')
    expect(home).to have_welcome_header
    expect(home.welcome_header.text).to eq('Welcome')
    expect(home).to have_welcome_messages(text: 'This is the home page, there is some stuff on it')
    expect(home).to have_rows
    expect(home.rows.first.text).to eq('a')
    expect(home).to have_rows(class: 'link_c')
  end

  it "can not match text" do
    home = @test_site.home.load
    expect(home.has_no_nonexistent_element?).to be true
    expect(home).to have_no_nonexistent_element
    expect(home).to have_no_welcome_header(text: "This Doesn't Match!")
  end

  it "can acess element properties" do
    home = @test_site.home.load
    expect(home).to have_link_to_search_page
    expect(home.link_to_search_page['href']).to include('search.htm')
    expect(home.link_to_search_page['class']).to eq('link link--undefined')
  end

  it "can check for expected elements" do
    hwee = @test_site.home_with_expected_elements.load
    expect(hwee).to be_all_there
  end

  it "can check for not expected elements" do
    home = @test_site.home.load
    expect(home).not_to be_all_there
  end

  it "can check for element presence" do
    exp = @test_site.section_experiments.load
    expect(exp.elements_present)
      .to eq(exp.class.mapped_items)
  end

  it "can check for element absence" do
    @test_site.home.load
    expect(@test_site.home.elements_present)
      .not_to eq(@test_site.home.class.mapped_items)
  end

  it "can get native property of element" do
    home = @test_site.home.load
    expect(home.welcome_header.native).to be_a Selenium::WebDriver::Element
  end
end
