# frozen_string_literal: true

require 'spec_helper'

feature'IFrame Interaction' do
  before do
    @test_site.home.load
  end

  it "can locate an iframe by id" do
    # @test_site.home.wait_for_my_iframe
    expect(@test_site.home).to have_my_iframe
  end

  it "can locate an iframe by index" do
    # @test_site.home.wait_for_index_iframe
    expect(@test_site.home).to have_index_iframe
  end

  it "can locate an iframe by name" do
    # @test_site.home.wait_for_named_iframe
    expect(@test_site.home).to have_named_iframe
  end

  it "can locate an iframe by xpath" do
    # @test_site.home.wait_for_xpath_iframe
    expect(@test_site.home).to have_xpath_iframe
  end

  it "can interact with elements in an iframe" do
    @test_site.home.my_iframe do |f|
      expect(f.some_text.text).to eq('Some text in an iframe')
      expect(f).to have_some_text(text: 'Some text in an iframe')
    end
  end
end
