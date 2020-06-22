# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Gift cards', type: :feature, js: true do
  scenario 'Purchase gift card' do
    # Gift cards landing page
    visit '/gift_cards?disable_experiments=new_design'
    click_link '3 months'

    count = ActionMailer::Base.deliveries.count

    find('textarea[id=gift_card_message]').send_keys('Surprise')
    find('input[id=gift_card_customer_email]').send_keys('featurespec@example.com')
    # Checkout page
    within_frame(0) do
      send_keys_to_card_field '4242424242424242'
      find('input[placeholder="MM / YY"]').send_keys '5'
      find('input[placeholder="MM / YY"]').send_keys '22'
      find('input[placeholder=CVC]').send_keys '123'
    end
    click_button 'Purchase gift card'

    # Wait for success page to render
    find('.gift_cards-thank_you', wait: 20)

    expect(ActionMailer::Base.deliveries.count).to eq(count + 1)

    # Confirmation page
    expect(page).to have_text 'Thank you for buying a gift card!'
    expect(page).to have_text 'featurespec@example.com'
  end
end
