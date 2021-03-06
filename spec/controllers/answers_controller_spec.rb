require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create :question, user: user }
  let(:answer)    { create(:answer, question: question, user: user) }
  let(:user)      { create :user }

  describe 'POST #create' do
    sign_in_user
    let(:channel) { "/questions/#{question.id}" }

    context 'with valid attributes' do
      let(:object) { post :create, answer: attributes_for(:answer), question_id: question }
      
      it 'saves the new answer in the database' do
        expect { object }.to change(question.answers, :count).by(1)
      end

      it 'assign user to created answer' do
        object
        expect(assigns(:answer).user).to eq subject.current_user
      end

      it_behaves_like 'publishable'
    end

    context 'with invalid attributes' do
      let(:object) { post :create, answer: attributes_for(:invalid_answer), question_id: question }

      it 'does not save the question' do
        expect { object }.to_not change(Answer, :count)
      end
      
      it_behaves_like 'not publishable'  
    end
  end

  describe 'PATCH #update' do
    context 'valid user' do
      sign_in_user
      let(:answer) { create(:answer, user: @user) }

      it 'assings the requested answer to @answer' do
        patch :update, id: answer, answer: attributes_for(:answer)
        expect(assigns(:answer)).to eq answer
      end

      it 'assigns the question' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer)
        expect(assigns(:question)).to eq question
      end

      it 'changes answer attributes' do
        patch :update, id: answer, answer: { body: 'new body' }
        answer.reload
        expect(answer.body).to eq 'new body'
      end
    end

    context 'invalid user' do
      sign_in_user
      let(:another_answer) { create(:answer, question: question, user: user) }
      it 'not assigns the requested answer to @answer' do

        patch :update, id: another_answer, answer: { body: 'new body' }
        another_answer.reload
        expect(another_answer.body).to_not eq 'new body'
      end

      it 'response with status 403' do
        patch :update, id: another_answer, answer: { body: 'new body' }
        expect(response).to have_http_status 403
      end
    end
  end

  describe 'PATCH #make_best' do
    let(:answer) { create(:answer, question: question, user: @user) }

    context 'correct user' do
      sign_in_user

      before do
        question.update(user: @user)
        patch :make_best, id: answer, question_id: question, format: :js
      end

      it 'sets #best to true' do
        answer.reload
        expect(answer).to be_best
      end

      it 'renders #make_best template' do
        expect(response).to render_template :make_best
      end
    end

    context 'incorrect user' do
      sign_in_user

      it 'doesnt change #best' do
        expect do
          patch :make_best, id: answer, question_id: question, format: :js
          answer.reload
        end.to_not change(answer, :best)
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    it 'delete his answer' do
      answer_for_del = Answer.create(body: answer.body, user: @user, question: question)

      expect { delete :destroy, question_id: question.id, id: answer_for_del, format: :js }.to change(Answer, :count).by(-1)
    end

    it 'delete not his answer' do
      answer
      expect { delete :destroy, question_id: question.id, id: answer, format: :js }.to_not change(Answer, :count)
    end
  end
end
