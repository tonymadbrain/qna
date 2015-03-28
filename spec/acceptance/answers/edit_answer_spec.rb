require_relative '../acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an autor of answer
  I'd like to be able to edit my answer
} do
  
  given(:user) { create :user }
  given(:other_user) { create :user }
  given!(:question) { create :question  }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
  
  describe 'Authenticated user' do
    describe 'like owner' do
      before do
        log_in user
        visit question_path(question)
      end

      scenario 'sees link to Edit' do
        within '.answers' do
          expect(page).to have_link 'Edit'
        end
      end

      scenario 'try to edit his answer', js: true do
        within '.answers' do
          click_on 'Edit'
          fill_in 'Answer', with: 'edited answer'
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
          expect(page).to_not have_content 'Edit'
      end
    end
  end
end