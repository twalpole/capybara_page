# frozen_string_literal: true

require 'spec_helper'

feature 'Interact with a section of a page' do
  it "can designate a page section" do
    @test_site.home.load
    expect(@test_site.home).to have_people
    expect(@test_site.home.people.headline).to have_content('People')
    expect(@test_site.home.people).to have_headline(text: 'People')

    @test_site.page_with_people.load
    expect(@test_site.page_with_people.people_list.headline).to have_content('People')
  end

  it "can access elements in the section by passing a block" do
    @test_site.home.load
    expect(@test_site.home).to have_people

    @test_site.home.people do |section|
      expect(section.headline.text).to eq('People')
      expect(section).to have_individuals(count: 4)
    end
    expect do
      @test_site.home.people { |section| expect(section).to have_dinosaur }
    end.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  it "can define a section in a section" do
    @test_site.section_experiments.load
    expect(@test_site.section_experiments.parent_section.child_section).to have_nice_label(text: 'something')
  end

  it "can define a section within a section using blocks" do
    @test_site.section_experiments.load

    expect(@test_site.section_experiments).to have_parent_section
    @test_site.section_experiments.parent_section do |parent|
      expect(parent.child_section.nice_label.text).to eq('something')

      parent.child_section do |child|
        expect(child).to have_nice_label(text: 'something')
      end
    end
  end

  it "can define a section within a section using class & blocks" do
    @test_site.home.load
    expect(@test_site.home.people).to have_headline
    expect(@test_site.home.people).to have_headline_clone
  end

  it "scopes to a section" do
    pending "nedd to work out the best way to do capybara methods here"
    @test_site.home.load
    expect(@test_site.home.has_welcome_message?).to be true

    @test_site.home.people do |section|
      expect(section).to have_no_css('.welcome')
      expect { section.has_welcome_message? }.to raise_error(NoMethodError)
    end
  end

  it "can have anonymous sections" do
    @test_site.section_experiments.load
    expect(@test_site.section_experiments.anonymous_section.title.text).to eq('Anonymous Section')
  end

  it "can check a section is visible" do
    @test_site.home.load
    expect(@test_site.home.people).to be_visible
  end

  it "can get root element belonging to section" do
    @test_site.home.load
    expect(@test_site.home.people.root_element.class).to eq(Capybara::Node::Element)
  end

  it "can check all elements are present" do
    @test_site.section_experiments.load
    expect(@test_site.section_experiments.search_results.first).to be_all_there
  end

  it "can call JS methods against a section" do
    @test_site.section_experiments.load
    @test_site.section_experiments.search_results.first.cell_value = 'wibble'
    expect(@test_site.section_experiments.search_results.first.cell_value).to eq('wibble')
  end

  it "can wait for a section" do
    @test_site.section_experiments.load
    @test_site.section_experiments.parent_section.wait_for_slow_section_element
    expect(@test_site.section_experiments.parent_section).to have_slow_section_element
  end

  it "can wait for a section to disappear" do
    @test_site.section_experiments.load
    @test_site.section_experiments.removing_parent_section.wait_for_no_removing_section_element
    expect(@test_site.section_experiments.removing_parent_section).not_to have_removing_section_element
  end

  it "raises exception when section doesn't appear" do
    @test_site.section_experiments.load
    expect { @test_site.section_experiments.parent_section.wait_for_slow_section_element(1) }
      .to raise_error(CapybaraPage::TimeOutWaitingForExistenceError)
      .with_message(/Timed out waiting for Parent#slow_section_element/)
  end

  it "raises exception when section doesn't disappear" do
    @test_site.section_experiments.load
    expect { @test_site.section_experiments.removing_parent_section.wait_for_no_removing_section_element(1) }
      .to raise_error(CapybaraPage::TimeOutWaitingForNonExistenceError)
      .with_message(/Timed out waiting for no Parent#removing_section_element/)
  end

  it "can get section parent" do
    home = @test_site.home
    home.load
    expect(home.people.parent).to eq(home)
  end

  it "can get parent section from a child section" do
    @test_site.section_experiments.load
    parent_section = @test_site.section_experiments.parent_section
    expect(parent_section.child_section.parent).to eq(parent_section)
  end

  it "can get page from child section" do
    exp = @test_site.section_experiments
    exp.load
    expect(exp.parent_section.child_section.parent.parent).to eq(exp)
  end

  it "can access page through child section" do
    exp = @test_site.section_experiments
    exp.load
    expect(exp.parent_section.child_section.parent_page).to eq(exp)
  end

  it "can have a page without a section" do
    home = @test_site.home
    home.load
    expect(home.has_no_nonexistent_section?).to be true
    expect(home).to have_no_nonexistent_section
  end

  it "can have a section with no element" do
    home = @test_site.home
    home.load
    expect(home.people).to have_no_dinosaur
  end

  it "can have a deeply nested section" do
    exp = @test_site.section_experiments
    exp.load
    deeply_nested_section = exp.level_1[0].level_2[0].level_3[0].level_4[0].level_5[0]
    expect(deeply_nested_section.deep_span.text).to eq('Deep span')
  end

  it "can get text from page section" do
    home = @test_site.home
    home.load
    expect(home.people.text).to eq("People\nperson 1 person 2 person 3 person 4 object 1")
    expect(home.container_with_element.text).to eq('This will be removed when you click submit above')
  end

  it "can get native property from section" do
    home = @test_site.home
    home.load
    expect(home.people.native).to be_a Selenium::WebDriver::Element
  end
end
