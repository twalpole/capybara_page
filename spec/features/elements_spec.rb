# frozen_string_literal: true

require 'spec_helper'

feature 'Interaction with groups of elements' do
  before do
    @home = @test_site.home.load
  end

  it "can get text from group of elements" do
    expect(@home.lots_of_links.map(&:text)).to eq(%w[a b c])
  end

  it "can get groups of elements from within a section" do
    expect(@home.people.individuals.size).to eq(4)
    expect(@home.people).to have_individuals(count: 4)

    expect(@home.people.optioned_individuals.size).to eq(4)
    expect(@home.people).to have_optioned_individuals(count: 4)
  end

  it "with no elements" do
    expect(@home.has_no_nonexistent_elements?).to be true
    expect(@home).to have_no_nonexistent_elements
  end

  it "waits for elements to appear" do
    @home.wait_for_lots_of_links
    @home.wait_for_lots_of_links(0.1)
    @home.wait_for_lots_of_links(0.1, count: 3)

    Capybara.using_wait_time(0.3) do
      # intentionally wait and pass nil to force this to cycle
      expect do
        @home.wait_for_lots_of_links(nil, count: 198_108_14)
      end.to raise_error CapybaraPage::TimeOutWaitingForExistenceError, /Timed out waiting for TestHomePage#lots_of_links/
    end
  end

  it "waits for elements to disappear" do
    @home.wait_for_no_removing_links
    @home.wait_for_no_removing_links(0.1)

    expect(@home.wait_for_no_removing_links(0.1, text: 'wibble')).to be true
  end
end
