require 'rails_helper'

feature 'Create answer', %q{
  For help user who ask question
  I want to be able give answer
  on question
} do

  given(:user) { create :user }
  given!(:question) { create :question }
  
  scenario 'Authenticated user tries create answer' do
    log_in(user)
    visit root_path
    click_on question.title
    click_on 'Create answer'
    fill_in 'Answer', with: 'test answer'
    click_on 'Create'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'test answer'
    expect(current_path).to eq "/questions/#{question.id}"
  end

  scenario 'Non-authenticated user tries to create answer' do
    visit root_path
    click_on question.title

    expect(page).to have_no_content 'Create answer'
  end
end
