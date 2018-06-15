# frozen_string_literal: true

require 'spec_helper'

describe CapybaraPage::Page do
  subject { Page.new }

  class PluralSections < CapybaraPage::Section; end

  class PluralSectionsWithDefaults < CapybaraPage::Section
    set_default_search_arguments :css, '.section'
  end

  class Page < CapybaraPage::Page
    sections :plural_sections,               PluralSections, '.tim'
    sections :plural_sections_with_defaults, PluralSectionsWithDefaults
  end

  describe '.sections' do
    it 'should be callable' do
      expect(CapybaraPage::Page).to respond_to(:sections)
    end
  end

  context 'with sections `plural_sections` defined' do
    it { is_expected.to respond_to(:plural_sections) }
    it { is_expected.to respond_to(:has_plural_sections?) }
  end

  context 'when using sections with default search arguments and without search arguments' do
    let(:search_arguments) { [:css, '.section', {}] }

    before do
      allow(subject)
        .to receive(:find_all)
        .with(*search_arguments)
        .and_return(%i[element1 element2])
    end

    it 'should use default arguments' do
      expect(CapybaraPage::Section).to receive(:new).with(subject, :element1).ordered
      expect(CapybaraPage::Section).to receive(:new).with(subject, :element2).ordered

      subject.plural_sections_with_defaults
    end
  end
end
