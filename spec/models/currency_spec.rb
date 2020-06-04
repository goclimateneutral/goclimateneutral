# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Currency do
  describe '.from_iso_code' do
    it 'returns existing currencies' do
      expect(described_class.from_iso_code(:sek)).to eq(described_class::SEK)
    end

    it 'returns nil when currency is not defined' do
      expect(described_class.from_iso_code(:xxx)).to be_nil
    end

    it 'returns nil when given nil' do
      expect(described_class.from_iso_code(nil)).to be_nil
    end

    it 'returns nil when given an empty string' do
      expect(described_class.from_iso_code('')).to be_nil
    end
  end

  describe '.prefix' do
    let(:translations) do
      {
        models: { currency: { prefix: { usd: nil } } }
      }
    end

    around do |example|
      with_translations(I18n.locale, translations) do
        example.run
      end
    end

    it 'returns nothing by default' do
      expect(described_class.from_iso_code(:usd).prefix).to be_nil
    end

    context 'when localized as DEFAULT' do
      let(:translations) do
        {
          models: { currency: { prefix: { usd: 'DEFAULT' } } }
        }
      end

      it 'returns nothing' do
        expect(described_class.from_iso_code(:usd).prefix).to be_nil
      end
    end

    context 'when localized' do
      let(:translations) do
        {
          models: { currency: { prefix: { usd: '$' } } }
        }
      end

      it 'returns localized prefix' do
        expect(described_class.from_iso_code(:usd).prefix).to eq('$')
      end
    end
  end

  describe '.suffix' do
    let(:translations) do
      {
        models: { currency: { suffix: { sek: nil } } }
      }
    end

    around do |example|
      with_translations(I18n.locale, translations) do
        example.run
      end
    end

    it 'returns nothing by default' do
      expect(described_class.from_iso_code(:sek).suffix).to be_nil
    end

    context 'when localized as DEFAULT' do
      let(:translations) do
        {
          models: { currency: { suffix: { sek: 'DEFAULT' } } }
        }
      end

      it 'returns nothing' do
        expect(described_class.from_iso_code(:sek).suffix).to be_nil
      end
    end

    context 'when localized' do
      let(:translations) do
        {
          models: { currency: { suffix: { sek: 'kr' } } }
        }
      end

      it 'returns localized suffix' do
        expect(described_class.from_iso_code(:sek).suffix).to eq('kr')
      end
    end
  end
end
