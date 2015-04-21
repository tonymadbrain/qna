require_relative '../acceptance_helper'

feature 'Add files to question' do
  
  given(:user) { create(:user) }
  given(:first_file) { "#{Rails.root}/spec/spec_helper.rb" }
  given(:second_file) { "#{Rails.root}/spec/rails_helper.rb" }

  background do
    log_in(user)
    visit new_question_path
  end

  scenario 'User attach file when asks question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'text text text'
    attach_file 'File', first_file
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'User attach several files when asks question', js: true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'text text text'
    click_on 'Add more'

    file_inputs = page.all('input[type="file"]')
    file_inputs[0].set first_file
    file_inputs[1].set second_file
    click_on 'Create'
    
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/3/rails_helper.rb'
  end

  scenario 'User attach file then delete him, and try to create question', js: true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'text text text'
    attach_file 'File', first_file
    click_on 'Clear'
    click_on 'Create'

    expect(page).to have_content 'Test question'
    expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end
end