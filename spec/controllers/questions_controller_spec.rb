require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  
  let(:user) { create :user } 
  let(:question) { create :question, user: user }
  let(:questions) { create_list(:question, 3, user: user) }

  describe 'GET #index' do
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns questions to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'authorized user GET #new' do
    sign_in_user
    before { get :new }
      
    it 'assigns new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'non-authorized user GET #new' do
    before { get :new }
    it 'redirect to log in form' do
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'authorized user GET #edit' do
    sign_in_user
    before { get :edit, id: question }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'non-authorized user GET #edit' do
    before { get :edit, id: question}
    it 'resirect to log in form' do
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'authorized user POST #create' do
    sign_in_user
    context 'with valid attr' do
      it 'save new question in database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attr' do
      it 'does not save new question in database' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-render new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'non-authorized user POST #create' do
    context 'with valid attr' do
      it 'dont save and redirect to new_user_session_path' do
        expect { post :create, question: attributes_for(:question) }.to_not change(Question, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'with invalid attr' do
      it 'dont save and redirect to new_user_session_path' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do 
    describe 'authorized user author' do
      sign_in_user
      let(:question) { create(:question, user: @user) } 
      context 'with valid attr' do
        it 'assigns the requested question with @question' do
          patch :update, id: question, question: attributes_for(:question), format: :js
          expect(assigns(:question)).to eq question
        end

        it 'change attr' do
          patch :update, id: question, question: { title: "Test title", body: "Test body" }, format: :js
          question.reload
          expect(question.title).to eq "Test title"
          expect(question.body).to eq "Test body"
        end
      end

      context 'with invalid attr' do
        before { patch :update, id: question, question: { title: "test title", body: nil }, format: :js }
        
        it 'does not change que attr' do
          question.reload
          expect(question.title).to eq "Super title"
          expect(question.body).to eq "Super text"
        end
      end
    end
    describe "authorized user not-author" 
  end

  describe 'non-authorized user PATCH #update' do
    context 'with valid attr' do
      it 'not assigns the requested question with @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(response).to redirect_to new_user_session_path
      end

      it 'not change attr' do
        patch :update, id: question, question: { title: "Test title", body: "Test body" }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'authorized user DELETE #destroy' do
    sign_in_user
    it 'delete his question from database' do
      question_for_del = Question.create(title: question.title, body: question.body, user_id: @user.id)
      expect { delete :destroy, id: question_for_del }.to change(Question, :count).by(-1)
      expect(response).to redirect_to questions_path
     end

    it 'delete other question from database' do
      question = Question.create(title: 'Fish question', body: 'Fish text', user: user)
      expect{ delete :destroy, id: question }.to_not change(Question, :count) 
    end
  end

  describe 'non-authorized user DELETE #destroy' do
    it 'not delete his question from database' do
      question
      expect { delete :destroy, id: question }.to_not change(Question, :count)
     end
  end
end