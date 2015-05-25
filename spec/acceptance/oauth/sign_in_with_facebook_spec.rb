require_relative '../acceptance_helper'

RSpec.feature 'Sign in with Facebook. In order to improve usability as a user I want to be able to sign in with Facebook', type: :feature do

  let(:unreg_user)  { build(:user) }
  let(:reg_user)    { create(:user) }

  scenario 'An unregistered user sign in with Facebook' do
    sign_in_soc_network(:facebook, { uid: '12345', info: { name: 'Alice', email: unreg_user.email } })

    visit new_user_session_path
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account'
    expect(page).to_not have_selector(:link_or_button, 'Log in')
    expect(page).to have_selector(:link_or_button, 'Log out')
    expect(current_path).to eq root_path
  end

  scenario 'A registered user sign in with Facebook' do
    sign_in_soc_network(:facebook, { uid: '12345', info: { name: 'Bob', email: reg_user.email } })

    visit new_user_session_path
    click_on 'Sign in with Facebook'
    
    expect(page).to have_content 'Successfully authenticated from Facebook account'
    expect(page).to_not have_selector(:link_or_button, 'Log in')
    expect(page).to have_selector(:link_or_button, 'Log out')
    expect(current_path).to eq root_path
  end

end