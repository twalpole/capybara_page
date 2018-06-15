# frozen_string_literal: true

require 'spec_helper'

feature 'Interaction with groups of elements' do
  before do
    @test_site.home.load
  end

  it "can get text from group of elements" do
    expect(@test_site.home.lots_of_links.map(&:text)).to eq(%w[a b c])
  end

  it "can get groups of elements from within a section" do
    expect(@test_site.home.people.individuals.size).to eq(4)
    expect(@test_site.home.people).to have_individuals(count: 4)

    expect(@test_site.home.people.optioned_individuals.size).to eq(4)
    expect(@test_site.home.people).to have_optioned_individuals(count: 4)
  end

  it "with no elements" do
    expect(@test_site.home.has_no_nonexistent_elements?).to be true
    expect(@test_site.home).to have_no_nonexistent_elements
  end

  it "waits for elements to appear" do
    @test_site.home.wait_for_lots_of_links
    @test_site.home.wait_for_lots_of_links(0.1)
    @test_site.home.wait_for_lots_of_links(0.1, count: 3)

    Capybara.using_wait_time(0.3) do
      # intentionally wait and pass nil to force this to cycle
      expect do
        @test_site.home.wait_for_lots_of_links(nil, count: 198_108_14)
      end.to raise_error CapybaraPage::TimeOutWaitingForExistenceError, /Timed out waiting for TestHomePage#lots_of_links/
    end
  end

  it "waits for elements to disappear" do
    @test_site.home.wait_for_no_removing_links
    @test_site.home.wait_for_no_removing_links(0.1)

    expect(@test_site.home.wait_for_no_removing_links(0.1, text: 'wibble')).to be true
  end
end
