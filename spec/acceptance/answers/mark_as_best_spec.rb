require_relative '../acceptance_helper'

feature 'Mark answer as best', "
    Like author of question
    I'd like to be able to mark some answer as best

" do

  given(:question_author) { create(:user) }
  given(:other_user) { create(:user) }

  given!(:question) { create(:question, user: question_author) }
  given!(:answers) { create_list(:answer, 3, question: question, user: other_user) }

  scenario 'Question author can accept any answer as the best answer', js: :true do
    log_in question_author
    answer = answers[0]
    visit question_path(question)

    within "#answer_#{ answer.id }" do
      click_on 'Best answer'
      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'This is best answer'
    end
  end

  scenario 'Only one answer can be the best answer', js: :true do
    log_in question_author
    first_best_answer = answers[1]

    visit question_path(question)
    within "#answer_#{ first_best_answer.id }" do
      click_on 'Best answer'
      expect(page).to have_content 'This is best answer'
    end

    other_best_answer = answers[2]
    within "#answer_#{ other_best_answer.id }" do
      click_on 'Best answer'
      expect(page).to have_content 'This is best answer'
    end

    within "#answer_#{ first_best_answer.id }" do
      expect(page).to_not have_content 'This is best answer'
    end
  end

  scenario 'Best answer should be the first in answers list', js: :true do
    log_in question_author
    visit question_path(question)

    first_answer = answers[0]
    second_answer = answers[1]

    first_answer_selector = '.answers div:first-child'

    first_answer_in_list = page.find(first_answer_selector)
    expect(first_answer_in_list).not_to have_content second_answer.body

    within "#answer_#{ second_answer.id }" do
      click_on 'Best answer'
    end

    first_answer_in_list = page.find(first_answer_selector)
    expect(first_answer_in_list).to have_content second_answer.body
  end

  scenario 'Other user can not accept answer as the best answer', js: :true do
    log_in other_user

    visit question_path(question.id)
    expect(page).not_to have_link 'Best answer'
  end

  scenario 'Guest can not accept answer as the best answer' do
    visit question_path(question.id)
    expect(page).not_to have_link 'Best answer'
  end
end
