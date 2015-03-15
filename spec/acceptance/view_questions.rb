require 'rails_helper'

feature 'View questions' do
  before do
    Question.create(title: 'Question1', body: 'text1')
    Question.create(title: 'Question2', body: 'text2')
    Question.create(title: 'Question3', body: 'text3')
  end
  
  scenario 'user get all questions' do
    visit root_path
    expect(page).to have_content 'Question1'
    expect(page).to have_content 'Question2'
    expect(page).to have_content 'Question3'
  end

  scenario 'user click on one question' do
    visit root_path
    click_on 'Question1'

    expect(page).to have_content 'Question1'
    expect(page).to have_content 'text1'
  end

  scenario 'view answers' do
    visit root_path
    click_on 'Question1'
    click_on 'create answer'
    fill_in 'Answer', with: 'question1 answer'
    click_on 'Create'

    expect(page).to have_content 'Question1'
    expect(page).to have_content 'text1'
    expect(page).to have_content 'question1 answer'
  end
end