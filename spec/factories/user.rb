# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    password { 'password' }
    stripe_customer_id { 'cus_TEST' }
    region { 'se' }
    lifestyle_footprints { [association(:lifestyle_footprint)] }

    factory :user_with_ended_subscription do
      subscription_end_at { 2.days.ago }
    end

    factory :user_with_subscription_ending_in_future do
      subscription_end_at { 2.days.from_now }
    end
  end
end
