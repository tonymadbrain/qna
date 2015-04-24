require_relative '../acceptance_helper'

feature 'Answer editing', "
  In order to fix mistake
  As an autor of answer
  I'd like to be able to edit my answer

" do

  given(:user) { create :user }
  given(:other_user) { create :user }
  given!(:question) { create :question, user: user }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user try to edit answer' do
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    describe 'like owner' do
      before do
        log_in user
        visit question_path(question)
      end

      scenario 'sees link to Edit' do
        within "#answer_#{ answer.id }" do
          expect(page).to have_link 'Edit'
        end
      end

      scenario 'try to edit his answer', js: true do
        within "#answer_#{ answer.id }" do
          click_on 'Edit'
          fill_in 'Edit answer', with: 'edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end
    end

    describe 'like not owner' do

      before do
        log_in other_user
        visit question_path(question)
      end

      scenario "don't sees link to Edit" do
        within '.answers' do
          expect(page).to_not have_content 'Edit'
        end
      end
    end
  end
end
