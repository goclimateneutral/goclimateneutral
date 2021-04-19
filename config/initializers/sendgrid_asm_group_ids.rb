# frozen_string_literal: true

SENDGRID_ASM_GROUP_IDS =
  if ENV['SENDGRID_ASM_GROUP_IDS'] == 'production'
    {
      subscription: 16_739,
      gift_card: 21_453,
      flight_offset: 22_943,
      invoice_certificates: 26_003,
      welcome: 27_414,
      payment_failed: 28_840,
      data_requests: 29_667
    }
  else
    {
      subscription: 8691,
      gift_card: 8345,
      flight_offset: 9519,
      invoice_certificates: 12_404,
      welcome: 13_849,
      payment_failed: 15_417,
      data_requests: 16_144
    }
  end
