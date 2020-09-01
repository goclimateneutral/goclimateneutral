# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Registrations', type: :feature, js: true do
  scenario 'Register and update card' do
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
    expect(page).to have_text 'Hello, climate friend!'

    # Go to payment settings page
    visit '/users/edit'
    find('.registrations-edit', wait: 20)
    click_link 'Payment settings'
    find('.subscriptions-show', wait: 20)

    expect(page).to have_text 'Payment settings'

    # Update card
    click_link 'Edit card'
    within_frame(0) do
      send_keys_to_card_field '4242424242424242'
      find('input[name=exp-date]').send_keys '522'
      find('input[name=cvc]').send_keys '123'
    end
    click_button 'Update'

    # Wait for payment page to render
    find('.subscriptions-show', wait: 20)

    # Unsubscribe
    find('#start_cancellation').click
    find('#confirm_cancellation', wait: 20).click
    expect(page).to have_text 'No subscription', wait: 20

    # Add new card and re-subscribe
    select('€10', from: 'Climate Plan')

    click_link 'Add new card'
    within_frame(0) do
      send_keys_to_card_field '5555555555554444'
      find('input[name=exp-date]').send_keys '522'
      find('input[name=cvc]').send_keys '123'
    end
    click_button 'Update'
    expect(page).to have_text 'Cancel subscription', wait: 20
  end

  context 'when using 3D Secure card' do
    scenario 'Register and update card' do
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
      within_frame(find('iframe[name=__privateStripeFrame8]', wait: 20)) do
        within_frame(find('iframe[id=challengeFrame]', wait: 20)) do
          within_frame(find('iframe.FullscreenFrame', wait: 20)) do
            # For some unknown reason, the Capybara click method does not work
            # within this iframe in Firefox, but evaluating JS that clicks does.
            find('#test-source-authorize-3ds', wait: 20).evaluate_script('this.click()')
          end
        end
      end

      # Wait for success page to render
      find('.dashboard-show', wait: 20)

      expect(page).to have_text 'Welcome to a climate neutral life'
      expect(page).to have_text 'Hello, climate friend!'

      # Go to payment settings page
      visit '/users/edit'
      find('.registrations-edit', wait: 20)
      click_link 'Payment settings'
      find('.subscriptions-show', wait: 20)

      expect(page).to have_text 'Payment settings'

      # Update card
      click_link 'Edit card'
      within_frame(0) do
        send_keys_to_card_field '4242424242424242'
        find('input[name=exp-date]').send_keys '522'
        find('input[name=cvc]').send_keys '123'
      end
      click_button 'Update'

      # Wait for payment page to render
      find('.subscriptions-show', wait: 20)

      # Unsubscribe
      find('#start_cancellation').click
      find('#confirm_cancellation', wait: 20).click
      expect(page).to have_text 'No subscription', wait: 20

      # Add new card and re-subscribe
      select('€10', from: 'Climate Plan')

      click_link 'Add new card'
      within_frame(0) do
        send_keys_to_card_field '5555555555554444'
        find('input[name=exp-date]').send_keys '522'
        find('input[name=cvc]').send_keys '123'
      end
      click_button 'Update'
      expect(page).to have_text 'Cancel subscription', wait: 20
    end
  end
end
