require 'rails_helper'

feature 'Delete Answer' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'user delete his answer' do
    log_in(user)

    visit "/questions/#{question.id}"
    click_on 'Create answer'
    fill_in 'Answer',  with: 'Test Answer'
    click_on 'Create'
    click_on 'Delete answer'

    expect(page).to have_content 'Answer successfully deleted.'
  end
end
