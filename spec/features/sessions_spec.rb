# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Sessions', type: :feature, js: true do
  scenario 'User signs in' do
    user = create(:user)

    if page.has_link?('user-menu')
      click_link('user-menu')
      click_link('Log out')
    end
    # Homepage
    visit '/'
    click_link 'Log In'

    # sign in page
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log In'

    # Wait for dashboard to render
    find('.dashboard-show', wait: 20)
    expect(page).to have_text 'Hello, climate friend!'
  end

  # We have lifestyle footprints in our db where country is nil
  scenario 'User where lifestyle_footprint.country is nil signs in' do
    user = create(:user)
    footprint = user.current_lifestyle_footprint
    footprint.country = nil
    footprint.save(:validate => false)

    if page.has_link?('user-menu')
      click_link('user-menu')
      click_link('Log out')
    end
    # Homepage
    visit '/'
    click_link 'Log In'

    # sign in page
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log In'

    # Wait for dashboard to render
    find('.dashboard-show', wait: 20)
    expect(page).to have_text 'Hello, climate friend!'
  end
end
