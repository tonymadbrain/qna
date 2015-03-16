require 'rails_helper'

feature 'User sign out' do

  given(:user) { create :user }

  scenario 'Registered and authorized user try to sign out' do

    log_in(user)
    #visit destroy_user_session_path
    visit root_path
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end
end