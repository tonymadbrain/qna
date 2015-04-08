require_relative '../acceptance_helper'

feature 'Question editing', %q{
    In order to fix mistake
    As an autor of question
    I'd like to be able to edit my question
} do
  
  given(:user) { create :user }
  given(:other_user) { create :user }
  given!(:question) { create :question, user: user  }

  scenario 'Author can edit his question without page reload', type: feature, js: true do
    log_in user
    visit question_path(question)
    click_on 'Edit'
    expect(current_path).to eq question_path(question)
    fill_in 'Title', with: 'Edited title'
    fill_in 'Question', with: 'Edited body'
    click_on 'Save'
    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Edited body'
  end
  
  scenario 'Users can not edit question of another user' do
    log_in other_user
    visit question_path(question)
    expect(page).not_to have_link 'Edit'
  end
  
  scenario 'Guest can not edit any questions' do
    visit question_path(question)
    expect(page).not_to have_link 'Edit'
  end
end