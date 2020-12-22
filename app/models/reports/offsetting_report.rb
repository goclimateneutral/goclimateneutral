# frozen_string_literal: true

require 'sql_report'

module Reports
  class OffsettingReport < SQLReport::Base
    select :subscription_months,
      columns: {
        count: 'count(id)',
        co2e: 'sum(co2e)'
      }
    select :gift_cards,
      columns: {
        count: 'count(id)',
        co2e: 'sum(co2e)'
      },
      where: 'paid_at IS NOT NULL'
    select :flight_offsets,
      columns: {
        count: 'count(id)',
        co2e: 'sum(co2e)'
      },
      where: 'paid_at IS NOT NULL'
    select :invoices,
      columns: {
        count: 'count(id)',
        sum: 'sum(co2e)'
      }
    select :climate_report_invoices,
      columns: {
        count: 'count(id)',
        sum: 'sum(co2e)'
      }
  end
end
