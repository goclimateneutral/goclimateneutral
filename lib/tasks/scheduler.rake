# frozen_string_literal: true

require 'stripe_events_consumer'

task update_stripe_events: :environment do
  puts 'Update StripeEvents...'
  StripeEventsConsumer.new.fetch_and_process
  puts 'done.'
end

task update_stripe_payouts: :environment do
  puts 'Update StripePayouts...'
  StripePayout.update_payouts
  puts 'done.'
  puts((StripePayout.sum(:amount) / 100).to_s + ' sek in payouts from Stripe')
end
