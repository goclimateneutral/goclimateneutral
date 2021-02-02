# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Registrations', type: :feature, js: true do
  scenario 'Register' do
    # Homepage
    visit '/'

    select('Sweden', from: 'country')
    click_button 'Get started'

    # Calculator
    find('label', text: 'Apartment').click
    find('label', text: 'Electricity').click
    find('label', text: 'Yes').click
    find('label', text: 'Vegetarian').click
    find('label', text: 'Every now and then').click
    find('label', text: 'I don\'t have a car').click
    click_button 'Next'

    # Sign up page
    find('#continue-to-payment').click
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'password'
    within_frame(0) do
      send_keys_to_card_field '4242424242424242'
      find('input[name=exp-date]').send_keys '522'
      find('input[name=cvc]').send_keys '123'
    end
    check 'I accept GoClimate\'s Privacy policy'
    click_button 'Start subscription'

    # Wait for success page to render
    find('.dashboard-show', wait: 30)

    expect(page).to have_text 'Welcome to a climate neutral life'
    expect(User.last.stripe_customer.subscriptions.first.status).to eq('active')
    expect(User.last.first_subscription_created_at.to_date).to eq(Time.now.to_date)
  end

  scenario 'Register with 3D Secure card' do
    # Homepage
    visit '/'

    select('Sweden', from: 'country')
    click_button 'Get started'

    # Calculator
    find('label', text: 'Apartment').click
    find('label', text: 'Electricity').click
    find('label', text: 'Yes').click
    find('label', text: 'Vegetarian').click
    find('label', text: 'Every now and then').click
    find('label', text: 'I don\'t have a car').click
    click_button 'Next'

    # Sign up page
    find('#continue-to-payment').click
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'password'
    within_frame(0) do
      send_keys_to_card_field '4000000000003063'
      find('input[name=exp-date]').send_keys '522'
      find('input[name=cvc]').send_keys '123'
    end
    check 'I accept GoClimate\'s Privacy policy'
    click_button 'Start subscription'

    # 3D Secure authorization pop up
    authorize_3d_secure

    # Wait for success page to render
    find('.dashboard-show', wait: 20)

    expect(page).to have_text 'Welcome to a climate neutral life'
    expect(User.last.stripe_customer.subscriptions.first.status).to eq('active')
    expect(User.last.first_subscription_created_at.to_date).to eq(Time.now.to_date)
  end

  scenario 'Register with referral code' do
    # Homepage
    visit '/?enable_experiments=new_signup'

    select('Sweden', from: 'country')
    click_button 'Get started'

    # Calculator
    find('label', text: 'Apartment').click
    find('label', text: 'Electricity').click
    find('label', text: 'Yes').click
    find('label', text: 'Vegetarian').click
    find('label', text: 'Every now and then').click
    find('label', text: 'I don\'t have a car').click
    click_button 'Next'

    # Sign up page
    find('label', text: 'Have a referral code?').click
    fill_in 'Referral code', with: 'gofriends'
    click_button 'OK'
    expect(page).to have_text 'First month free'

    find('#continue-to-payment').click
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'password'
    within_frame(0) do
      send_keys_to_card_field '4000002500003155'
      find('input[name=exp-date]').send_keys '522'
      find('input[name=cvc]').send_keys '123'
    end
    check 'I accept GoClimate\'s Privacy policy'
    click_button 'Start subscription'

    # 3D Secure authorization pop up
    authorize_3d_secure

    # Wait for success page to render
    find('.dashboard-show', wait: 20)

    expect(page).to have_text 'Welcome to a climate neutral life'
    expect(Stripe::Invoice.retrieve(User.last.stripe_customer.subscriptions.first.latest_invoice).total).to eq(0)
    expect(User.last.stripe_customer.subscriptions.first.status).to eq('trialing')
    expect(User.last.first_subscription_created_at.to_date).to eq(Time.now.to_date)
    subscription = nil
    expect { subscription = trigger_next_subscription_charge }.not_to raise_error
    expect(subscription.status).to eq('active')
  end

  scenario 'Register without subscription' do
    visit '/'

    select('Sweden', from: 'country')
    click_button 'Get started'

    # Calculator
    find('label', text: 'Apartment').click
    find('label', text: 'Electricity').click
    find('label', text: 'Yes').click
    find('label', text: 'Vegetarian').click
    find('label', text: 'Every now and then').click
    find('label', text: 'I don\'t have a car').click
    click_button 'Next'

    # Sign up page
    find('input#free', wait: 20).click
    find('#continue-to-payment').click
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'password'
    check 'I accept GoClimate\'s Privacy policy'
    click_button 'Create account'

    # Wait for success page to render
    find('.dashboard-show', wait: 20)
    expect(page).to have_text 'Welcome to GoClimate!'
    expect(User.last.stripe_customer.subscriptions.first).to eq(nil)
    expect(User.last.first_subscription_created_at).to eq(nil)
  end

  scenario 'Register through campaign page' do
    # Campaign page
    visit '/know-your-carbon-footprint'

    within '#first-registration-form' do
      select('Sweden', from: 'country')
      click_button 'Get started'
    end

    # Calculator
    find('label', text: 'Apartment').click
    find('label', text: 'Electricity').click
    find('label', text: 'Yes').click
    find('label', text: 'Vegetarian').click
    find('label', text: 'Every now and then').click
    find('label', text: 'I don\'t have a car').click
    click_button 'Next'

    # Result page
    click_button 'Continue to payment'
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'password'
    within_frame(0) do
      send_keys_to_card_field '4242424242424242'
      find('input[name=exp-date]').send_keys '522'
      find('input[name=cvc]').send_keys '123'
    end
    check 'I accept GoClimate\'s Privacy policy'
    click_button 'Start subscription'

    # Wait for success page to render
    find('.dashboard-show', wait: 30)

    expect(page).to have_text 'Welcome to a climate neutral life'
    expect(User.last.stripe_customer.subscriptions.first.status).to eq('active')
    expect(User.last.first_subscription_created_at.to_date).to eq(Time.now.to_date)
  end

  scenario 'Register through campaign page with 3D Secure card' do
    # Campaign page
    visit '/know-your-carbon-footprint'

    within '#first-registration-form' do
      select('Sweden', from: 'country')
      click_button 'Get started'
    end

    # Calculator
    find('label', text: 'Apartment').click
    find('label', text: 'Electricity').click
    find('label', text: 'Yes').click
    find('label', text: 'Vegetarian').click
    find('label', text: 'Every now and then').click
    find('label', text: 'I don\'t have a car').click
    click_button 'Next'

    # Result page
    click_button 'Continue to payment'
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'password'
    within_frame(0) do
      send_keys_to_card_field '4000000000003063'
      find('input[name=exp-date]').send_keys '522'
      find('input[name=cvc]').send_keys '123'
    end
    check 'I accept GoClimate\'s Privacy policy'
    click_button 'Start subscription'

    # 3D Secure authorization pop up
    authorize_3d_secure

    # Wait for success page to render
    find('.dashboard-show', wait: 30)

    expect(page).to have_text 'Welcome to a climate neutral life'
    expect(User.last.stripe_customer.subscriptions.first.status).to eq('active')
    expect(User.last.first_subscription_created_at.to_date).to eq(Time.now.to_date)
  end

  scenario 'Register through campaign page without subscription' do
    # Campaign page
    visit '/know-your-carbon-footprint'

    within '#first-registration-form' do
      select('Sweden', from: 'country')
      click_button 'Get started'
    end

    # Calculator
    find('label', text: 'Apartment').click
    find('label', text: 'Electricity').click
    find('label', text: 'Yes').click
    find('label', text: 'Vegetarian').click
    find('label', text: 'Every now and then').click
    find('label', text: 'I don\'t have a car').click
    click_button 'Next'

    # Result page
    click_button 'Sign up'
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'password'
    check 'I accept GoClimate\'s Privacy policy'
    click_button 'Create account'

    # Wait for success page to render
    find('.dashboard-show', wait: 30)

    expect(page).to have_text 'Welcome to GoClimate!'
    expect(User.last.stripe_customer.subscriptions.first).to eq(nil)
    expect(User.last.first_subscription_created_at).to eq(nil)
  end

  def trigger_next_subscription_charge
    Stripe::Subscription.update(
      User.last.stripe_customer.subscriptions.first.id,
      billing_cycle_anchor: 'now',
      # This wouldn't happen in production of course, but we need to end the trial to trigger the next charge
      trial_end: 'now',
      proration_behavior: 'none',
      off_session: true
    )
  end
end
