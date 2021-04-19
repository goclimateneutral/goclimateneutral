# frozen_string_literal: true

class WelcomeMailer < ApplicationMailer
  default asm: { group_id: SENDGRID_ASM_GROUP_IDS[:welcome] }

  def welcome_email
    mail(
      from: "#{I18n.t('mailers.welcome.from', name: 'Tove')} <tove@goclimate.com>",
      reply_to: "#{I18n.t('mailers.welcome.from', name: 'Tove')} <tove@goclimate.com>",
      to: params[:email],
      subject: I18n.t('mailers.welcome.subject')
    )
  end
end
