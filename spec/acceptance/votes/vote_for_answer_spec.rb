require_relative '../acceptance_helper'

feature 'User can vote for the answer that he liked', type: :feature, js: true do

  given(:user)              { create(:user) }
  given(:another_user)      { create(:user) }
  given!(:question)          { create(:question, user: user) }
  given!(:answer)            { create(:answer, question: question, user: user) }
  given!(:another_answer)    { create(:answer, question: question, user: another_user) }
  
  background do
    log_in(another_user)
    visit question_path(question)
  end
  
  scenario 'User can see buttons for like/dislike' do
    within "#answer_#{ answer.id }" do
      expect(page).to have_content '+'
      expect(page).to have_content '-'
      expect(page).to have_content 'Rating: 0'
    end
  end

  scenario 'User can vote for answer only once' do
    within "#answer_#{ answer.id }" do
      click_link '+'
      expect(page).to have_content 'Rating: 1'
      expect(page).to_not have_content '+'
      expect(page).to have_content "-"
    end
  end
  
  scenario 'User can cancel his vote and re-vote' do
    within "#answer_#{ answer.id }" do
      click_link '+'
      expect(page).to have_content 'Rating: 1'
      click_link "-"
      expect(page).to have_content 'Rating: 0'
      click_link '-'
      expect(page).to have_content 'Rating: -1'
    end
  end

  scenario "User can't vote for self question" do
    within "#answer_#{ another_answer.id }" do
      expect(page).to_not have_content '+'
      expect(page).to_not have_content '-'
    end
  end
end
