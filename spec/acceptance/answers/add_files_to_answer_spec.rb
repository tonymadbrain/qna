require_relative '../acceptance_helper'

feature 'Add files to answer' do
  
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background do
    log_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when give answer' do
    fill_in 'Answer', with: 'Test answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end