# frozen_string_literal: true

class Money
  include Comparable
  attr_reader :subunit_amount, :currency

  def self.from_amount(amount, currency)
    new((amount.to_d * 100).round, currency)
  end

  def initialize(subunit_amount, currency)
    raise ArgumentError, 'Amount cannot be nil' if subunit_amount.nil?
    raise ArgumentError, 'Amount must be an integer' unless subunit_amount.is_a?(Integer)
    raise ArgumentError, 'Currency cannot be nil' if currency.nil?

    @subunit_amount = subunit_amount
    @currency = currency.is_a?(Symbol) ? Currency.from_iso_code(currency) : currency
  end

  def <=>(other)
    return nil unless currency == other&.currency

    subunit_amount <=> other.subunit_amount
  end

  def *(other)
    Money.new((subunit_amount * other).round, currency)
  end

  def ceil(precision = nil)
    Money.new(subunit_amount.ceil(precision || -2), currency)
  end

  def amount
    BigDecimal(subunit_amount) / 100
  end

  def to_s(precision: nil)
    formatting_options = { format: '%n' }
    unless precision.nil?
      formatting_options[:precision] =
        if precision == :auto
          subunit_amount % 100 == 0 ? 0 : 2
        else
          precision
        end
    end
    formatted_number = ActiveSupport::NumberHelper.number_to_currency(amount, formatting_options)

    localized_string = I18n.t(
      "models.money.currency_formats.#{currency.iso_code}",
      number: formatted_number, default: 'DEFAULT', fallback: false
    )

    if localized_string == 'DEFAULT'
      "#{currency} #{formatted_number}"
    else
      localized_string
    end
  end

  def inspect
    I18n.with_locale(:en) { "#{currency} #{ActiveSupport::NumberHelper.number_to_currency(amount, format: '%n')}" }
  end
end
