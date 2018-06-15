# frozen_string_literal: true

require 'spec_helper'

feature 'Interaction with a group of sections' do
  it "can access a collection of sections" do
    @test_site.section_experiments.load
    @test_site.section_experiments.search_results.each_with_index do |search_result, i|
      expect(search_result.title.text).to eq("title #{i}")
      expect(search_result.description.text).to eq("description #{i}")
    end
    expect(@test_site.section_experiments.search_results.size).to eq(4)
  end

  it "waits for a collection of sections to disappear" do
    @test_site.home.load
    @test_site.home.wait_for_no_removing_sections
    expect(@test_site.home).not_to have_removing_sections
  end

  it "can access a collection of anonymous sections" do
    @test_site.section_experiments.load
    @test_site.section_experiments.anonymous_sections.each_with_index do |section, index|
      expect(section.title.text).to eq("Section #{index}")
      expect(section.downcase_title_text).to eq("section #{index}")
    end
    expect(@test_site.section_experiments.anonymous_sections.size).to eq(2)
  end
end
