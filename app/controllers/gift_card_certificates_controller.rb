# frozen_string_literal: true

class GiftCardCertificatesController < ApplicationController
  def show
    gift_card = GiftCard.find_by_key(params[:key])
    pdf = GiftCardCertificatePdf.new(gift_card).render

    send_data pdf, filename: 'GoClimate Gift Card.pdf', type: :pdf
  end

  # This is a preview version of the gift card. Includes sample text and a big EXAMPLE stamp.
  # Optionally, you can include a subscription_months_to_gift query param.
  def example
    number_of_months = (params[:subscription_months_to_gift].presence || 6).to_i
    country =
      ISO3166::Country.new(params[:country]) ||
      visitor_country ||
      ISO3166::Country.new('US')

    pdf = GiftCardCertificatePdf.new(
      GiftCard.new(
        message: t('views.gift_cards.example.message_html'),
        number_of_months: number_of_months,
        country: country
      ),
      example: true
    ).render

    send_data pdf, filename: 'GoClimate Gift Card.pdf', type: :pdf, disposition: :inline
  end
end
