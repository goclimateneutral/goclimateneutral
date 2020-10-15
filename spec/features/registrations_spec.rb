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
    check 'I accept our Privacy policy'
    click_button 'Start subscription'

    # Wait for success page to render
    find('.dashboard-show', wait: 30)

    expect(page).to have_text 'Welcome to a climate neutral life'
    expect(User.last.stripe_customer.subscriptions.first.status).to eq('active')
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
    check 'I accept our Privacy policy'
    click_button 'Start subscription'

    # 3D Secure authorization pop up
    authorize_3d_secure

    # Wait for success page to render
    find('.dashboard-show', wait: 20)

    expect(page).to have_text 'Welcome to a climate neutral life'
    expect(User.last.stripe_customer.subscriptions.first.status).to eq('active')
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
    find('label', text: 'I don\'t have a car').click
    click_button 'Next'

    # Sign up page behind feature flag
    # TODO: remove feature flag
    visit "#{current_url}&sign_up_without_subscription=2"

    # Sign up page
    find('input#free', wait: 20).click
    find('#continue-to-payment').click
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'password'
    check 'I accept our Privacy policy'
    click_button 'Create account'

    # Wait for success page to render
    find('.dashboard-show', wait: 20)
    expect(page).to have_text 'Welcome to GoClimate!'
  end
end
