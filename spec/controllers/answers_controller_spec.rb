require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create :question }
  let(:answer) { create :answer, question: question }  
  
  describe 'GET #new' do
    before { get :new, question_id: question }

    it 'assigns new answer to answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render answer/new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, question_id: question, id: answer }

    it 'assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render answer/edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attr' do
      it 'right save new answer in db' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(Answer, :count).by(1)
        expect(assigns(:answer).question_id).to eq answer.question_id
      end

      it 'redirect to answer/show view' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(assigns(:answer).question)
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
    before { answer } 

    it 'delete answer from database' do
       expect { delete :destroy, question_id: question, id: answer }.to change(Answer, :count).by(-1)
     end

    it 'redirect to answer/index view' do
      delete :destroy, question_id: question, id: answer
      expect(response).to redirect_to question_path(assigns(:answer).question)
    end
  end
end
