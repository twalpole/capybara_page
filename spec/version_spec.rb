# frozen_string_literal: true

require 'spec_helper'

describe 'CapybaraPage::VERSION' do
  subject { CapybaraPage::VERSION }

  it { is_expected.to be_truthy }
end
