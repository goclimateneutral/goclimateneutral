# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Business signup', type: :feature, js: true do
  scenario 'Sign up via climate report' do
    visit '/business'

    click_link 'Calculate my business footprint'

    # Wait for climate report form to render
    find('#climate-report-form', wait: 20)

    fill_in 'climate_report_company_name', with: 'Test AB'
    fill_in 'climate_report_employees', with: '4'
    fill_in 'climate_report_contact_email', with: 'test@example.com'
    click_button 'See my business footprint'

    # Wait for climate report form to render
    find('#climate-report', wait: 20)

    expect(page).to have_text('Your business footprint')

    fill_in 'climate_report_invoice_invoice_address', with: <<~TEXT
      Testvägen 1
      111 22 Staden
    TEXT

    click_button 'Order'

    # Wait for thank you page to render
    find('.climate_report_invoices-thank_you', wait: 20)

    expect(page).to have_text('Thank you!')
  end
end
