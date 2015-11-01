require_relative 'acceptance_helper'

feature 'User rating', type: :feature, js: true do
  given(:user) { create(:user) }
  given!(:question) { create :question, user: user }

  scenario 'When user answer on question, his rating increases on 1 point' do
    skip "add some examples to (or delete) #{__FILE__}"
    # log_in(user)
    # visit question_path(question)

    # fill_in 'Answer', with: 'test answer'
    # click_on 'Create'

    # visit user_path(user)
    # within '#rating' do
    #   expect(page).to have_content '1'
    # end
  end

  scenario 'When user vote for question, author of question receives 2 points' do
    skip "add some examples to (or delete) #{__FILE__}"
  end
  scenario 'When user vote for answer, author of answer receives 1 points' do
    skip "add some examples to (or delete) #{__FILE__}"
  end
  scenario 'When user vote against question, author of question receives -2 points' do
    skip "add some examples to (or delete) #{__FILE__}"
  end
  scenario 'When user vote against answer, author of answer receives -1 points' do
    skip "add some examples to (or delete) #{__FILE__}"
  end
  scenario 'If users answer is best, he receives 3 points' do
    skip "add some examples to (or delete) #{__FILE__}"
  end
  scenario 'If user answer on question first, hi receives 1 point' do
    skip "add some examples to (or delete) #{__FILE__}"
  end
  scenario 'If user answered on his question first hi receives 3 points' do
    skip "add some examples to (or delete) #{__FILE__}"
  end
  scenario 'If user answered on his question hi receives 2 points' do
    skip "add some examples to (or delete) #{__FILE__}"
  end
end
