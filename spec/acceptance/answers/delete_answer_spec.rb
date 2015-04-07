require_relative '../acceptance_helper'

feature 'Delete Answer' do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create :answer, question: question, user: user }

  scenario 'author delete his answer', js: true do
    log_in user 
    answer
    visit question_path(question)
    within "#answer_#{ answer.id }" do
      click_on 'Delete'
    end
    expect(page).to_not have_content answer.body
  end

  scenario 'another user cant delete answer' do
    log_in user
    visit question_path(question)

    expect(page).to_not have_content 'Delete'
  end
end
