# frozen_string_literal: true

class DataRequestMailer < ApplicationMailer
  default asm: { group_id: SENDGRID_ASM_GROUP_IDS[:data_requests] }
  helper :application

  def data_request_email
    mail(
      from: "#{I18n.t('mailers.welcome.from', name: 'Alexandra')} <alexandra@goclimate.com>",
      reply_to: "#{I18n.t('mailers.welcome.from', name: 'Alexandra')} <alexandra@goclimate.com>",
      to: params[:data_reporter].email,
      subject: I18n.t('mailers.data_requests.subject')
    )
  end
end
