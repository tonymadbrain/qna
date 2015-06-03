require 'rails_helper'

describe 'Questions API' do
  let(:access_token) { create(:access_token) }
  let(:user)         { create(:user) }
  let!(:resource) { 'question' }  

  describe 'GET /index' do
    it_behaves_like 'API unauthorized'

    context 'authorized' do
      let!(:questions) { create_list(:question, 3, user: user) }
      let(:question)   { questions.first }
      let!(:answer)    { create(:answer, question: question, user: user) }

      before { do_request access_token: access_token.token }

      it_behaves_like 'API 200_and_list'

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get api_v1_questions_path, { format: :json }.merge(options)  
    end
  end

  describe 'GET /show' do
    let!(:question)    { create(:question, user: user) }
    it_behaves_like 'API unauthorized'

    context 'authorized' do
      let!(:comment)    { create(:comment, commentable: question) }
      let!(:attachment) { create(:attachment, attachable: question) }

      before { do_request format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      it_behaves_like 'API commentable'
      it_behaves_like 'API attachable'
    end

    def do_request(options = {})
      get api_v1_question_path(question), { format: :json }.merge(options)  
    end
  end

  describe 'POST /create' do
    let(:question) { build(:question) }
    let(:owner_user) { User.find(access_token.resource_owner_id) }

    context 'unauthorized' do
      it 'returns status unauthorized if access_token is not provided' do
        do_request question: attributes_for(:question)
        expect(response).to be_unauthorized
      end

      it 'returns status unauthorized if access_token is invalid' do
        do_request access_token: SecureRandom.hex, question: attributes_for(:question)
        expect(response).to be_unauthorized
      end
    end

    context 'authorized' do
      let(:object_attr)     { [{ question: attributes_for(:question) }, { question: attributes_for(:invalid_question) }] }
      let!(:list_for_check) { Question }
      it_behaves_like 'API creatable'
    end

    def do_request(options = {})
      post api_v1_questions_path, { format: :json }.merge(options)  
    end
  end
end