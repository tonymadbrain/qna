require_relative '../acceptance_helper'

RSpec.feature "Subscription", type: :feature do
  describe 'authenticated user' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:subscribed_question) { create(:question, user: user) }

    before do
      sign_in user
    end

    scenario 'subscribes to question' do
      visit question_path(question)
      click_on 'Subscribe'
      expect(page).to have_content 'Subscribed successfully!'
    end

    scenario 'unsubscribes from question' do
      visit question_path(subscribed_question)
      click_on 'Unsubscribe'
      expect(page).to have_content 'Unsubscribed successfully!'
    end
  end
end