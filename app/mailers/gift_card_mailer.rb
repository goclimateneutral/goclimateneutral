# frozen_string_literal: true

class GiftCardMailer < ApplicationMailer
  default asm: { group_id: 21_453 }

  def gift_card_email
    @number_of_months = params[:number_of_months]

    attachments['GoClimateNeutral Gift Card.pdf'] = params[:gift_card_pdf]

    mail(
      to: params[:email],
      subject: I18n.t('gift_card_email_subject')
    )
  end
end
