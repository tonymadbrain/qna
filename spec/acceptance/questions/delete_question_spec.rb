require 'rails_helper'

feature 'User can delete question' do

  given(:user) { create :user }

  before { Question.create(title: 'Question for delete', body: 'test fish text') }

  scenario 'authorized user can delete his question' do
    log_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'test fish text'
    click_on 'Create'
    click_on 'delete question'
    expect(page).to have_content 'You question successfully deleted.'
    expect(current_path).to eq questions_path
  end

  scenario 'authorized user cant delete not his question' do
    log_in(user)
  
    visit questions_path
    click_on 'Question for delete'
    click_on 'delete question'
    expect(page).to have_content 'You cant delete this question.'
  end

  scenario "some description" #non-authorized user tries delete question ?

end