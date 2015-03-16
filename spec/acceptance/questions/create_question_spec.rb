require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an user
  I want to be able to ask question
} do
  
  given(:user) { create :user }

  scenario 'Authenticated user create the question' do

    log_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'test fish text'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    expect(page).to have_no_content 'Ask question'
  end
end