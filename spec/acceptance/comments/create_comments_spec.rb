require_relative '../acceptance_helper'

RSpec.feature 'Comments', type: :feature, js: true do
  
  given!(:user)     { create :user }
  given!(:question) { create :question, user: user }
  given!(:answer)   { create :answer, user: user, question: question }

  context 'Authenticated user' do
    before do
      log_in user 
      visit question_path(question)
    end

    scenario 'creates new comment for a question' do
      within '#create-question-comment' do
        click_on 'New comment'
        fill_in 'Comment body', with: 'My question comment'
        click_on 'Create'
      end
      
      within '.question-comments' do
        expect(page).to have_content 'My question comment'
        expect(page).to have_content user.email
      end
    end

    scenario 'creates new comment for an answer' do
      within '#create-answer-comment' do
        click_on 'New comment'
        fill_in 'Comment body', with: 'My answer comment'
        click_on 'Create'
      end

      within '.answer-comments' do
        expect(page).to have_content 'My answer comment'
        expect(page).to have_content user.email
      end
    end
  end

  context 'Unauthenticated user' do
    before { visit question_path(question) }

    scenario 'can not comment a answer' do
        expect(page).not_to have_link 'New comment'
    end
  end
end