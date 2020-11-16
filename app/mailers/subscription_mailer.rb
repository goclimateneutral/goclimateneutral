# frozen_string_literal: true

class SubscriptionMailer < ApplicationMailer
  before_action :set_user
  around_action :use_user_locale

  default to: -> { @user.email },
          asm: { group_id: SENDGRID_ASM_GROUP_IDS[:subscription] }

  helper :subscription_mailer

  def one_more_month_email
    @climate_neutral_months = @user.number_of_neutral_months
    @total_carbon_offset = OffsettingStatistics.new.total_sold.tonnes.round

    mail subject: I18n.t('thank_you')
  end

  def one_more_year_email
    @climate_neutral_years = @user.number_of_neutral_months / 12
    @total_carbon_offset = OffsettingStatistics.new.total_sold.tonnes.round

    mail subject: I18n.t('thank_you')
  end

  def payment_failed_email
    mail subject: I18n.t('the_payment_unfortunately_failed'),
         asm: { group_id: SENDGRID_ASM_GROUP_IDS[:payment_failed] }
  end

  protected

  def set_user
    @user = User.find_by_email(params[:email])
  end

  def use_user_locale(&block)
    I18n.with_locale(@user.region.locale, &block)
  end

  def default_url_options
    super.merge({ region: @user.region })
  end
end
