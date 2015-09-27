require_relative 'acceptance_helper'

feature 'Show user profiles', type: :feature, js: true do
  given!(:user) { create :user }

  scenario 'Any user can see list of users' do
    visit users_path

    expect(page).to have_content user.email
  end
end