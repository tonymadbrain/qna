require_relative '../acceptance_helper'

feature 'Question editing', %q{
    In order to fix mistake
    As an autor of question
    I'd like to be able to edit my question
} do
  
  given!(:user) { create :user }
  given(:other_user) { create :user }
  given!(:question) { create :question  }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)
    within '.question' do
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
        within '.question' do
          expect(page).to have_content 'Edit'
        end
      end

      scenario 'try to edit his question', js: true do
        within '.question' do
          click_on 'Edit'
          fill_in 'Text', with: 'Edited question'
          click_on 'Save'

          expect(page).to_not have_content question.body
          expect(page).to have_content 'Edited question'
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
        within '.question' do
          expect(page).to_not have_content 'Edit'
        end
      end
    end
  end

end