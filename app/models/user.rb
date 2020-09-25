# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  has_many :card_charges, primary_key: 'stripe_customer_id', foreign_key: 'stripe_customer_id'
  has_many :lifestyle_footprints

  scope :with_active_subscription, lambda {
    where(subscription_end_at: nil).or(where('subscription_end_at >= ?', Time.now))
  }

  validates :user_name, format: { without: /.+@.+\..+/ }, allow_blank: true

  attribute :region, :region

  # accessor and validator of :privacy_policy are only here for client side validation via the ClientSideValidations gem
  validates :privacy_policy, acceptance: true
  attr_accessor :privacy_policy

  def stripe_customer
    Stripe::Customer.retrieve(stripe_customer_id) if stripe_customer_id.present?
  end

  def subscription_amount
    return 0 unless stripe_customer
    
    stripe_customer.subscriptions.first.plan.amount.to_f / 100
  end

  def subscription_amount_in_sek
    return 0 unless stripe_customer
    
    case Currency.from_iso_code(stripe_customer.subscriptions.first.plan.currency)
    when Currency::USD
      subscription_amount * GreenhouseGases::PRICE_FACTOR_USD
    when Currency::EUR
      subscription_amount * GreenhouseGases::PRICE_FACTOR_EUR
    else
      subscription_amount
    end
  end

  def country_name
    if !country.nil? && !country.empty?
      c = ISO3166::Country[country]
      c.translations[I18n.locale.to_s] || country.name
    else
      'Unknown'
    end
  end

  def number_of_neutral_months
    @number_of_neutral_months ||= card_charges.for_subscriptions.paid.count
  end

  def currency
    card_charges.first.currency
  end

  def update_without_password(params, *options)
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  def update_from_stripe_subscription(stripe_subscription)
    self.subscription_end_at = subscription_end_at_from_stripe(stripe_subscription)
    save
  end

  def current_lifestyle_footprint
    lifestyle_footprints.order(:created_at).last
  end

  def is_free_user
    return true unless stripe_customer
    return false
  end

  private

  def subscription_end_at_from_stripe(stripe_subscription)
    Time.at(stripe_subscription.ended_at) if stripe_subscription.ended_at.present?
  end
end
