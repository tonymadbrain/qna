require_relative 'acceptance_helper'

feature 'Show user profiles', type: :feature, js: true do
  given!(:users) { create_list(:user, 3) }

  scenario 'Any user can see list of users' do
    visit users_path

    expect(page).to have_content users[0].email
    expect(page).to have_content users[1].email
    expect(page).to have_content users[2].email
  end

  scenario 'Any user can see user page' do
    visit users_path

    click_on users[0].email
    expect(page).to have_content users[0].email
    # expect(page).to have_content users[0].first_name
    # expect(page).to have_content users[0].second_name
    # expect(page).to have_content users[0].rating
  end

  scenario 'Button "Users" on index page open users page' do
    visit root_path
    click_on 'Users'

    expect(page).to have_content users[0].email
    expect(page).to have_content users[1].email
    expect(page).to have_content users[2].email
  end
end