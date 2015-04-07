require_relative '../acceptance_helper'

feature 'Create answer', %q{
  For help user who ask question
  I want to be able give answer
  on question
} do

  given(:user) { create :user }
  given!(:question) { create :question, user: user }
  
  scenario 'Authenticated user tries create answer with valid attr', js: true  do
    log_in(user)
    visit question_path(question)
    
    fill_in 'Answer', with: 'test answer'
    click_on 'Create'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'test answer'
    end
  end

  scenario 'User try to create invalid answer', js: true do
    log_in(user)
    visit question_path(question)

    click_on 'Create'
    
    expect(page).to have_content "Body can't be blank"
  end  

  scenario 'Non-authenticated user tries to create answer' do
    visit root_path
    click_on question.title

    expect(page).to have_no_content 'Create answer'
  end
end
