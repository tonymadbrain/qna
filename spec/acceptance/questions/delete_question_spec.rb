require_relative '../acceptance_helper'

feature 'Delete question' do

  given(:user) { create :user }
  given(:another_user) { create :user }
  given(:question) { create :question, user: user}

  scenario 'authorized user can delete his question' do
    log_in(user)
    question
    visit question_path(question)
    click_on 'Delete question'
    expect(page).to have_content 'You question successfully deleted.'
    expect(page).to have_no_content question.title
    expect(current_path).to eq questions_path
  end

  scenario 'authorized user cant delete not his question' do
    log_in(another_user)
    visit question_path(question)
    expect(page).to have_no_content 'Delete question'
  end

  scenario 'non-authorized user tries delete question' do
    visit question_path(question)
    expect(page).to have_no_content 'Delete question'
  end

end