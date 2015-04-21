require_relative '../acceptance_helper'

feature 'Delete files attached to question' do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:file) { create(:attachment, attachable: question) }

  describe 'valid user' do
    
    background do
      log_in(user)
      visit question_path(question)
    end

    scenario 'author tries to delete attached file', js: true do
      click_on 'Delete file'
      expect(page).to_not have_link 'spec_helper.rb'
    end
  end

  describe 'invalid user' do
    
    scenario "not author don't sees link to delete file" do
      log_in(another_user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete file'
    end

    scenario "un-authenticated user don't sees link to delete file" do
      visit question_path(question)
      
      expect(page).to_not have_link 'Delete file'
    end
  end
end