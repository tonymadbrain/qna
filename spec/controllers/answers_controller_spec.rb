require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create :question }
  let(:answer) { create(:answer, question: question) }
  let(:user) { create :user } 

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, answer: attributes_for(:answer), question_id: question, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, answer: attributes_for(:answer), question_id: question, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js }.to_not change(Answer, :count)
      end

      it 'render create template' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    context 'valid user' do
      sign_in_user
      let(:answer) { create(:answer, question: question, user: @user) }

      it 'assings the requested answer to @answer' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'assigns the question' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes answer attributes' do
        patch :update, id: answer, question_id: question, answer: { body: 'new body'}, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'render update template' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :update
      end
    end

    context 'invalid user' do
      sign_in_user
      let(:another_answer) { create(:answer, question: question) }
      it 'not assigns the requested answer to @answer' do
      
        patch :update, id: another_answer, question_id: question, answer: { body: 'new body'}, format: :js
        another_answer.reload
        expect(another_answer.body).to_not eq 'new body'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'valid user' do
      sign_in_user
      let(:answer) { create(:answer, question: question, user: @user) }
      
      it 'deletes the answer' do
        expect { delete :destroy, question_id: question, id: answer, format: :js }.to change(Answer, :count).by(-1)
      end
    end

    context 'invalid user' do
      sign_in_user
      let(:another_answer) { create(:answer, question: question) }

      it "can't delete the answer" do
        expect { delete :destroy, question_id: question, id: another_answer }.not_to change(Answer, :count)
      end
    end

    context 'guest user' do
      it 'can not to delete the answer' do
        answer
        expect { delete :destroy, question_id: answer.question, id: answer }.not_to change(Answer, :count)
      end

      it 'redirects to sign in page' do
        delete :destroy, question_id: answer.question, id: answer
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
