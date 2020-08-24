# frozen_string_literal: true

module StripeExtensions
  module Plan
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def retrieve_or_create_climate_offset_plan(monthly_amount)
        raise ArgumentError, 'Plans must have an amount' if monthly_amount.subunit_amount == 0

        retrieve(plan_id(monthly_amount))
      rescue ::Stripe::InvalidRequestError
        create(climate_offset_plan_params(monthly_amount))
      end

      private

      def climate_offset_plan_params(monthly_amount)
        {
          id: plan_id(monthly_amount),
          interval: 'month',
          currency: monthly_amount.currency.iso_code,
          amount: monthly_amount.subunit_amount,
          product: { name: product_name(monthly_amount) }
        }
      end

      def plan_id(monthly_amount)
        "climate_offset_#{monthly_amount.amount.to_s.gsub(/[.,]/, '_')}_#{monthly_amount.currency.iso_code}_monthly"
      end

      def product_name(monthly_amount)
        "Climate Offset #{monthly_amount.amount} #{monthly_amount.currency.iso_code} Monthly"
      end
    end
  end
end

Stripe::Plan.include(StripeExtensions::Plan)
