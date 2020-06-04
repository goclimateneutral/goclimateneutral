# frozen_string_literal: true

Currency = Struct.new(:iso_code) do
  def self.from_iso_code(iso_code)
    return nil unless iso_code.present?

    "Currency::#{iso_code.upcase}".constantize
  rescue NameError
    nil
  end

  def to_s
    iso_code.to_s.upcase
  end

  def prefix
    prefix = I18n.translate("models.currency.prefix.#{iso_code}", default: 'DEFAULT', fallback: false)
    prefix unless prefix == 'DEFAULT'
  end

  def suffix
    suffix = I18n.translate("models.currency.suffix.#{iso_code}", default: 'DEFAULT', fallback: false)
    suffix unless suffix == 'DEFAULT'
  end
end

Currency::SEK = Currency.new(:sek)
Currency::EUR = Currency.new(:eur)
Currency::USD = Currency.new(:usd)

Currency::SEK_PER_USD = 8.5
Currency::SEK_PER_EUR = 10
