require 'rails_helper'

feature 'Create question', %q{
  In orger to get answer from community
  As an user
  I want to be able to ask question
} do
  
  scenario 'User create the question' do
    #User.create!(email: 'user@test.com', password: 'qwerty123')

    visit '/questions'
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'test fish text'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
  end
end