require_relative '../acceptance_helper'

feature 'Search. 
In order to find interesting question user be able to use search mechanism.' do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 2, body: 'Question') }
  given!(:question) { create(:question, title: 'Latest Question', body: 'the body') }
  given!(:answer) { create(:answer, question: question, user: user, body: 'latest answer') }
  given!(:comment) { create(:comment, commentable: question, user: user, body: 'latest comment') }

  scenario 'User searches globally', js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'query', with: 'latest'
      select('Everywhere', from: 'condition')
      click_on 'Search'

      expect(current_path).to eq search_path

      expect(page).to have_content 'latest answer'
      expect(page).to have_content 'latest comment'
      expect(page).to have_content 'Latest Question'
      within '.results' do
        expect(page).to have_selector('div', count: 3)
      end
    end
  end

  scenario 'User searches a question by title or body', js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'query', with: 'the body'
      select('Questions', from: 'condition')
      click_on 'Search'

      expect(current_path).to eq search_path
      expect(page).to have_content 'Latest Question'
      within '.results' do
        expect(page).to have_selector('div', count: 1)
      end
    end
  end

  scenario 'User searches a question by answer', js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'query', with: 'latest answer'
      select('Answers', from: 'condition')
      click_on 'Search'

      expect(current_path).to eq search_path
      expect(page).to have_content 'latest answer'
      within '.results' do
        expect(page).to have_selector('div', count: 1)
      end
    end
  end

  scenario 'User searches a question by comment', js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'query', with: 'latest comment'
      select('Comments', from: 'condition')
      click_on 'Search'

      expect(current_path).to eq search_path
      expect(page).to have_content 'latest comment'
      within '.results' do
        expect(page).to have_selector('div', count: 1)
      end
    end
  end

  scenario 'User searches a question by users email', js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'query', with: question.user.email
      select('Users', from: 'condition')
      click_on 'Search'

      expect(current_path).to eq search_path
      expect(page).to have_content question.user.email
      within '.results' do
        expect(page).to have_selector('div', count: 1)
      end
    end
  end
end