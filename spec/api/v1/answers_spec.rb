require 'rails_helper'

describe 'Answers API' do
  let!(:user)         { create(:user) }
  let!(:question)     { create(:question, user: user) }
  let(:access_token)  { create(:access_token) }
  let!(:resource) { 'answer' }

  describe 'GET /index' do
    let!(:answers)  { create_list(:answer, 3, question: question, user: user) }
    let!(:answer)   { question.answers.first }
    it_behaves_like 'API unauthorized'

    context 'authorized' do
      before { do_request access_token: access_token.token }

      it_behaves_like 'API 200_and_list'

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
      let(:object_attr)     { [{ answer: attributes_for(:answer) }, { answer: attributes_for(:invalid_answer) }] }
      let!(:list_for_check) { question.answers }
      it_behaves_like 'API creatable'
    end

    def do_request(options = {})
      post api_v1_question_answers_path(question), { format: :json }.merge(options)  
    end
  end
end