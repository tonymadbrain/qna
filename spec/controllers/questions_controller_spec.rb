require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  
  let(:question) { create :question }
  let(:questions) { create_list(:question, 2) }

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
      expect(assignd(:question)).to eq question
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, id: question }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attr' do
      it 'save new question in database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'redirect to show view' do
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

  describe 'PATCH #update' do
    let(:test_title) { expect(question.title).to eq "Test title" }
    let(:test_body) { expect(question.body).to eq "Test body" } 

    context 'with valid attr' do
      it 'assigns the requested question with @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq question
      end

      it 'change attr' do
        patch :update, id: question, question: { title: "Test title", body: "Test body" }
        question.reload
        test_title
        test_body
      end
    end

    context 'with invalid attr' do
      before { patch :update, id: question, question: attributes_for(:invalid_question) }
      
      it 'not change que attr' do
        question.reload
        test_title
        test_body
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end 
  end

  describe 'DELETE #destroy' do
    before { question } 

    it 'delete question from database' do
       expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
     end

    it 'redirect to index view' do
      expect(response).to redirect_to :index
    end
  end
end