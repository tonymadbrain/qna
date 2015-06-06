require_relative '../acceptance_helper'

RSpec.feature "Subscription", type: :feature do
  describe 'authenticated user' do
    let(:user)         { create(:user) }
    let!(:another_user) { create(:user) }
    let!(:question)     { create(:question, user: user) }

    before do
      log_in another_user
      visit question_path(question)
    end

    scenario 'subscribes to question' do
      click_on 'Subscribe'
      expect(page).to have_content 'Subscribed successfully!'
    end

    scenario 'unsubscribes from question' do
      click_on 'Subscribe'
      click_on 'Unsubscribe'
      expect(page).to have_content 'Unsubscribed successfully!'
    end
  end
end