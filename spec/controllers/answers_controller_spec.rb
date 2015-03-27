require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create :question }
  let(:answer) { create(:answer, question: question) }

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
    describe 'like owner' do
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

    describe 'like other user' do
      sign_in_user

      it 'not assigns the requested answer to @answer' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to_not eq answer
      end
    end
  end

  #describe 'DELETE #destroy' do
  #  sign_in_user
  #  it 'delete his answer' do
  #    answer_for_del = Answer.create(body: answer.body, user: @user, question: question)

  #    expect { delete :destroy, question_id: question.id, id: answer_for_del }.to change(Answer, :count).by(-1)
  #    expect(response).to redirect_to question
  #  end

  #  it 'delete not his answer' do
  #    answer
  #    expect { delete :destroy, question_id: question.id, id: answer }.to_not change(Answer, :count)
  #    expect(response).to redirect_to question
  #  end
  #end
end
