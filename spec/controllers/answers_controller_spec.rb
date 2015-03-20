require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create :question }  
  let(:user) { create :user }
  let(:answer) { create :answer, question: question, user: user }
  
  describe 'GET #new' do
    sign_in_user
    before { get :new, question_id: question }

    it 'assigns new answer to answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render answer/new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, question_id: question, id: answer }

    it 'assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render answer/edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attr' do
      it 'save new answer in db' do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attr' do
      it 'does not save new answer in database' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end

      it 're-render new view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do 
    sign_in_user
    context 'with valid attr' do
      it 'assigns the requested answer with @answer' do
        patch :update, question_id: question, id: answer, answer: attributes_for(:answer)
        expect(assigns(:answer)).to eq answer
      end

      it 'change attr' do
        patch :update, question_id: question, id: answer, answer: { body: "Test body" }
        answer.reload
        expect(answer.body).to eq "Test body"
      end

      it 'redirect to the updated answer' do
        patch :update, question_id: question, id: answer, answer: attributes_for(:answer)
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attr' do
      before { patch :update, question_id: question, id: answer, answer: { body: nil } }
      
      it 'does not change answer attr' do
        answer.reload
        expect(answer.body).to eq "Super answer text"
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end 
  end

  describe 'DELETE #destroy' do
    sign_in_user
    it 'delete his answer' do
      answer_for_del = Answer.create(body: answer.body, user: @user, question: question)

      expect { delete :destroy, question_id: question.id, id: answer_for_del }.to change(Answer, :count).by(-1)
      expect(response).to redirect_to question
    end

    it 'delete not his answer' do
      answer
      expect { delete :destroy, question_id: question.id, id: answer }.to_not change(Answer, :count)
      expect(response).to redirect_to question
    end
  end
end
