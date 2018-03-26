# frozen_string_literal: true

require 'spec_helper'

describe CapybaraPage::Page do
  describe '.section' do
    context 'second argument is not a Class and a block given' do
      context 'block given' do
        it 'should create an anonymous section with the block' do
          class PageWithSection < CapybaraPage::Page
            section :anonymous_section, '.section' do |s|
              s.element :title, 'h1'
            end
          end

          page = PageWithSection.new
          expect(page).to respond_to(:anonymous_section)
        end
      end
    end

    context 'second argument is not a class and no block given' do
      subject(:section) { Page.section(:incorrect_section, '.section') }

      it 'should raise an ArgumentError' do
        class Page < CapybaraPage::Page; end

        expect { section }
          .to raise_error(ArgumentError)
          .with_message('You should provide section class either as a block, or as the second argument.')
      end
    end
  end
end

describe CapybaraPage::Section do
  let(:a_page) { class Page < CapybaraPage::Page; end }

  it 'responds to element' do
    expect(CapybaraPage::Section).to respond_to(:element)
  end

  it 'responds to elements' do
    expect(CapybaraPage::Section).to respond_to(:elements)
  end

  it 'passes a given block to Capybara.within' do
    expect(Capybara).to receive(:within).with('div')

    CapybaraPage::Section.new(a_page, 'div') { 1 + 1 }
  end

  it 'does not require a block' do
    expect(Capybara).not_to receive(:within)

    CapybaraPage::Section.new(a_page, 'div')
  end
end
