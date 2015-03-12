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
    before { get :edit, question_id: question }

    it 'assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq @answer
    end

    it 'render answer/edit' do
      expect(response).to render_template :edit
    end
  end
end
