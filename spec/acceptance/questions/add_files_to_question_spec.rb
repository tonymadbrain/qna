require_relative '../acceptance_helper'

feature 'Add files to question' do
  
  given(:user) { create(:user) }

  background do
    log_in(user)
    visit new_question_path
  end

  scenario 'User adds fil when asks question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'text text text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end
end