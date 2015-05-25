require_relative '../acceptance_helper'

RSpec.feature 'Sign in with Twitter in order to improve usability as a user I want to be able to sign in with Twitter', type: :feature do

  let(:unreg_user)      { build(:user) }
  let!(:reg_ident_user) { create(:user) }
  let!(:identity)       { create(:identity, user: reg_ident_user, uid: '12345', provider: 'twitter') }
  let!(:reg_user)       { create(:user) }

  scenario 'An unregistered user sign in with Twitter' do
    sign_in_soc_network(:twitter, uid: '54321', info: { name: 'Alice' })

    visit new_user_session_path
    click_on 'Sign in with Twitter'

    expect(current_path).to eq new_user_registration_path
    expect(page).to_not have_field 'Password'

    fill_in 'Email', with: unreg_user.email
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(page).to_not have_selector(:link_or_button, 'Log in')
    expect(page).to have_selector(:link_or_button, 'Sign out')
    expect(current_path).to eq root_path
  end

  scenario "An unregistered user sign in with Twitter and doesn't fill email field" do
    sign_in_soc_network(:twitter, uid: '54321', info: { name: 'Alice' })

    visit new_user_session_path
    click_on 'Sign in with Twitter'

    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
    expect(current_path).to eq user_registration_path
  end

  scenario 'A registered user with identity sign in with Twitter' do
    sign_in_soc_network(:twitter, { uid: identity.uid, info: { name: 'Bob' } })

    visit new_user_session_path
    click_on 'Sign in with Twitter'
    
    expect(page).to have_content 'Successfully authenticated from Twitter account'
    expect(page).to_not have_selector(:link_or_button, 'Log in')
    expect(page).to have_selector(:link_or_button, 'Sign out')
    expect(current_path).to eq root_path
  end

  scenario 'A registered user without identity sign in with Twitter' do
    sign_in_soc_network(:twitter, { uid: '54321', provider: 'twitter' })

    visit new_user_session_path
    click_on 'Sign in with Twitter'

    fill_in 'Email', with: reg_user.email
    click_on 'Sign up'

    expect(page).to have_content 'Please confirm your email.'

    open_email(reg_user.email)
    current_email.click_on 'Confirm your email now'

    expect(page).to have_content 'Successfully authenticated from Twitter account'
    expect(page).to_not have_selector(:link_or_button, 'Log in')
    expect(page).to have_selector(:link_or_button, 'Sign out')
    expect(current_path).to eq root_path
  end

end