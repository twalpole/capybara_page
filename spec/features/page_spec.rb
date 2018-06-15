# frozen_string_literal: true

require 'spec_helper'

feature 'Page properties' do
  before do
    @home = @test_site.home.load
  end

  it "can get the html" do
    expect(@home.html).to include('<span class="welcome">This is the home page')
  end

  it "can get the text" do
    expect(@home.text).to include('This is the home page, there is some stuff on it')
  end

  it "can get the url" do
    expect(@home.current_url).to include('/home.htm')
  end

  it "can see the page is not secture" do
    expect(@home).not_to be_secure
  end

  it "can see the title" do
    expect(@home.title).to eq('Home Page')
  end

  it "can see no title" do
    nt = @test_site.no_title.load
    expect(nt.title).to eq('')
  end
end
