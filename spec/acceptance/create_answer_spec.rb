require 'rails_helper'

feature 'Create answer', %q{
  For help user who ask question
  I want to be able give answer
  on question
} do

  before do
    Question.create(title: 'Test answer', body: 'fish text for test answer question')
  end

  scenario 'create answer' do
    visit root_path
    click_on 'Test answer'
    click_on 'create answer'
    fill_in 'Answer', with: 'test answer'
    click_on 'Create'

    expect(page).to  have_content 'Your answer successfully created.'
  end
end
