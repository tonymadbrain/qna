require 'rails_helper'

describe 'Answers API' do
  let!(:user)         { create(:user) }
  let!(:question)     { create(:question, user: user) }
  let(:access_token)  { create(:access_token) }

  describe 'GET /index' do
    let!(:answers)  { create_list(:answer, 3, question: question, user: user) }
    let!(:answer)   { question.answers.first }
    it_behaves_like 'API unauthorized'

    context 'authorized' do
      before { do_request access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(3).at_path("answers")
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get api_v1_question_answers_path(question), { format: :json }.merge(options)  
    end
  end

  describe 'GET /show' do
    let(:answer)     { create(:answer, question: question, user: user) }
    it_behaves_like 'API unauthorized'

    context 'authorized' do
      let!(:comment)    { create(:comment, commentable: answer) }
      let!(:attachment) { create(:attachment, attachable: answer) }
      let!(:resource) { 'answer' }

      before { do_request access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      it_behaves_like 'API commentable'
      it_behaves_like 'API attachable'
    end

    def do_request(options = {})
      get api_v1_answer_path(answer), { format: :json }.merge(options)  
    end
  end

  describe 'POST /create' do
    let(:question)   { create(:question, user: user) }
    let(:answer)     { build(:answer, user: user) }
    let(:owner_user) { User.find(access_token.resource_owner_id) } 
    it_behaves_like 'API unauthorized'

    context 'authorized' do
      context 'with valid attributes' do
        it 'returns 201 status code' do
          do_request access_token: access_token.token, answer: attributes_for(:answer)
          expect(response.status).to eq 201
        end

        it 'saves the new answer to database' do
          expect { do_request access_token: access_token.token, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
        end

        it 'assign new answer to current user' do
          do_request access_token: access_token.token, answer: attributes_for(:answer)
          expect(assigns(:answer).user).to eq(owner_user)
        end
      end

      context 'with invalid attributes' do
        it 'returns 422 status code' do
          do_request access_token: access_token.token, answer: attributes_for(:invalid_answer)
          expect(response.status).to eq 422
        end

        it 'not saves the new answer to database' do
          expect { do_request access_token: access_token.token, answer: attributes_for(:invalid_answer) }.to_not change(question.answers, :count)
        end
      end
    end

    def do_request(options = {})
      post api_v1_question_answers_path(question), { format: :json }.merge(options)  
    end
  end
end