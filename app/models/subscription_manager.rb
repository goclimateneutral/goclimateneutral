# frozen_string_literal: true

class SubscriptionManager
  BUFFER_FACTOR = 2

  attr_reader :customer, :errors

  def self.price_for_footprint(footprint, currency)
    monthly_offset = footprint / 12 * BUFFER_FACTOR
    price = monthly_offset.consumer_price(currency)

    case price.currency
    when Currency::SEK
      Money.new(
        ((price.subunit_amount.to_d / 5).ceil(-2) * 5).to_i,
        :sek
      )
    else
      price
    end
  end

  def initialize(customer = nil)
    @customer = customer
    @errors = {}
  end

  def sign_up(email, plan, payment_method_id)
    handle_errors_and_return_status do
      use_or_create_customer(email)
      update_default_card(payment_method_id)
      create_subscription(plan)
    end
  end

  def set_up_new_customer(email, plan, payment_method_id)
    handle_errors_and_return_status do
      use_or_create_customer(email)
      update_default_card(payment_method_id)
      create_subscription(plan)
    end
  end

  def cancel
    subscription.delete
  end

  def remove_payment_methods
    payment_methods = Stripe::PaymentMethod.list(customer: customer.id, type: 'card')
    payment_methods.each do |payment_method|
      Stripe::PaymentMethod.detach(payment_method.id)
    end
  end

  def update(new_plan, payment_method_id = nil)
    handle_errors_and_return_status do
      update_default_card(payment_method_id) if payment_method_id.present?

      if subscription.nil?
        create_subscription(new_plan)
      elsif subscription.plan.id != new_plan.id
        update_subscription(new_plan)
      end
    end
  end

  def payment_verification_required?
    subscription.status == 'incomplete' && latest_payment_intent&.status == 'requires_action'
  end

  def latest_payment_intent
    subscription.latest_invoice&.payment_intent
  end

  def subscription
    @subscription ||= Stripe::Subscription.list(
      customer: @customer.id,
      expand: ['data.latest_invoice.payment_intent'],
      limit: 1
    ).first
  end

  private

  def handle_errors_and_return_status
    yield

    true
  rescue Stripe::CardError => e
    errors[e.code&.to_sym || :generic] = e.message || e.to_s

    false
  end

  def use_or_create_customer(email)
    @customer = Stripe::Customer.create(email: email) unless @customer.present?
  end

  def create_subscription(plan)
    @subscription = Stripe::Subscription.create(
      customer: customer.id,
      plan: plan.id,
      expand: ['latest_invoice.payment_intent']
    )
  end

  def update_subscription(new_plan)
    @subscription = Stripe::Subscription.update(
      subscription.id,
      prorate: false,
      plan: new_plan.id,
      expand: ['latest_invoice.payment_intent']
    )
  end

  def update_default_card(payment_method)
    Stripe::PaymentMethod.attach(payment_method, customer: customer.id)
    Stripe::Customer.update(customer.id, invoice_settings: { default_payment_method: payment_method })
  end
end
