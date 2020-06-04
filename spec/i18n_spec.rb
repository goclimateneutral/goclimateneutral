# frozen_string_literal: true

require 'i18n/tasks'

RSpec.describe 'config/locales/*.yml' do # rubocop:disable RSpec/DescribeClass
  let(:i18n) { I18n::Tasks::BaseTask.new }

  describe 'en.yml' do
    it 'includes all keys in use' do
      missing_keys = i18n.missing_keys(locales: [:en])

      expect(missing_keys)
        .to be_empty, "Missing #{missing_keys.leaves.count} i18n keys, run `bin/i18n-tasks missing --locales en' to show them"
    end
  end

  it 'include only used keys' do
    unused_keys = i18n.unused_keys

    expect(unused_keys)
      .to be_empty, "#{unused_keys.leaves.count} unused i18n keys, run `bin/i18n-tasks unused' to show them"
  end

  it 'use consistent interpolations' do
    inconsistent_interpolations = i18n.inconsistent_interpolations

    expect(inconsistent_interpolations).to be_empty, <<~TEXT
      #{inconsistent_interpolations.leaves.count} i18n keys have inconsistent interpolations.
      Run `bin/i18n-tasks check-consistent-interpolations' to show them
    TEXT
  end
end
