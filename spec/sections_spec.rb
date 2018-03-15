# frozen_string_literal: true

require 'spec_helper'

describe CapybaraPage::Page do
  let(:page) { APage.new }

  class SingleSection < CapybaraPage::Section; end
  class PluralSection < CapybaraPage::Section; end

  class APage < CapybaraPage::Page
    section  :single_section,  SingleSection, '.bob'
    sections :plural_sections, PluralSection, '.tim'
  end

  describe '.section' do
    it 'should be callable' do
      expect(CapybaraPage::Page).to respond_to(:section)
    end

    it 'should create matching object method' do
      expect(page).to respond_to(:single_section)
    end

    it 'should create matching existence method' do
      expect(page).to respond_to(:has_single_section?)
    end
  end

  describe '.sections' do
    it 'should be callable' do
      expect(CapybaraPage::Page).to respond_to(:sections)
    end

    it 'should create matching object method' do
      expect(page).to respond_to(:plural_sections)
    end

    it 'should create a matching existence method' do
      expect(page).to respond_to(:has_plural_sections?)
    end
  end
end
