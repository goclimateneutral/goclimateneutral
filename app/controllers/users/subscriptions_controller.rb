# frozen_string_literal: true

module Users
  class SubscriptionsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_stripe_customer

    def show
      @customer_payment_method = customer_payment_method(@stripe_customer)
      @setup_intent = Stripe::SetupIntent.create(customer: @stripe_customer.id)
      @current_plan_price =
        if @stripe_customer.subscriptions.total_count > 0
          plan = @stripe_customer.subscriptions.first.plan
          Money.new(plan.amount, Currency.from_iso_code(plan.currency))
        end
      @available_plans = available_plans(@current_plan_price)
    end

    def update
      @manager = SubscriptionManager.new(@stripe_customer)

      @current_plan_price = Money.from_amount(plan_param, customer_currency)
      new_plan = Stripe::Plan.retrieve_or_create_climate_offset_plan(@current_plan_price)

      if @manager.update(new_plan, params[:paymentMethodId])
        render_successful_update
      else
        render_bad_request(@manager.errors)
      end
    end

    def destroy
      @manager = SubscriptionManager.new(@stripe_customer)
      @manager.cancel
      @manager.remove_payment_methods
      redirect_to action: :show
    end

    private

    def available_plans(current_plan_price)
      starting_plan_price = current_plan_price&.amount || 0
      plans =
        if customer_currency == Currency::SEK
          (10...starting_plan_price + 300).step(5)
        else
          (2...starting_plan_price + 30)
        end.to_a

      plans.push(current_plan_price.amount) if current_plan_price.present? && !plans.include?(current_plan_price.amount)

      plans.sort.map { |amount| Money.from_amount(amount, customer_currency) }
    end

    def render_bad_request(errors)
      render json: { error: errors }, status: :bad_request
    end

    def set_stripe_customer
      @stripe_customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
    end

    def customer_currency
      Currency.from_iso_code(@stripe_customer.currency) || current_region.currency
    end

    def customer_payment_method(customer)
      return nil unless customer.invoice_settings&.default_payment_method

      Stripe::PaymentMethod.retrieve(customer.invoice_settings.default_payment_method)
    end

    def update_subscription(new_plan)
      @manager.update(
        new_plan,
        card_source_param,
        params[:three_d_secure] == 'continue' ? params[:source] : nil
      )
    end

    def render_successful_update
      flash[:notice] = I18n.t('your_payment_details_have_been_updated')
      render json: { redirectTo: user_subscription_path, notice: notice }, status: :ok
    end

    def plan_param
      params[:user][:plan]
    end

    def card_source_param
      params[:stripeSource]
    end
  end
end
