require_relative '../acceptance_helper'

feature 'Add files to answer' do
  
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:first_file) { "#{Rails.root}/spec/spec_helper.rb" }
  given(:second_file) { "#{Rails.root}/spec/rails_helper.rb" }

  background do
    log_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when give answer', js: true do
    fill_in 'Answer', with: 'Test answer'
    attach_file 'File', first_file
    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'User attach several files when give answer', js: true do
    fill_in 'Answer', with: 'Test answer'
    click_on 'Add more'

    file_inputs = page.all('input[type="file"]')
    file_inputs[0].set first_file
    file_inputs[1].set second_file
    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end
end