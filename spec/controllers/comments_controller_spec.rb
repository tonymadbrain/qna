require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  let(:user)      { create(:user) }
  let!(:question)  { create(:question, user: user) }
  let(:comment)   { create(:comment) }
  let(:answer)    { create(:answer, question: question, user: user) }

  describe 'GET #create' do

    context 'Authenticated user' do
      sign_in_user
      it 'creates new comment for a question' do
        expect { post :create, comment: attributes_for(:comment), commentable: 'question', question_id: question, format: :js }.to change(question.comments, :count).by 1
      end

      it 'creates new comment for an answer' do
        expect { post :create, comment: attributes_for(:comment), commentable: 'answer', question_id: question, answer_id: answer, format: :js }.to change(answer.comments, :count).by 1
      end
    end

    context 'Non authenticated user' do
      it 'cannot create comment' do
        expect { post :create, comment: attributes_for(:comment), question_id: question, format: :js }.to_not change(Comment, :count)
      end
    end
  end
end
