require 'rails_helper'

feature 'Delete question' do

  given(:user) { create :user }
  given(:question) { create :question}

  scenario 'authorized user can delete his question' do
    log_in(user)

    visit root_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'test fish text'
    click_on 'Create'
    click_on 'Delete question'
    expect(page).to have_content 'You question successfully deleted.'
    expect(page).to have_no_content 'Test question'
    expect(current_path).to eq questions_path
  end

  scenario 'authorized user cant delete not his question' do
    log_in(user)
  
    visit "/questions/#{question.id}"
    click_on 'Delete question'
    expect(page).to have_content 'You cant delete this question.'

    visit root_path
    expect(page).to have_content question.title
  end

  scenario 'non-authorized user tries delete question' do
    visit "/questions/#{question.id}"
    expect(page).to have_no_content 'Delete question'
  end

end