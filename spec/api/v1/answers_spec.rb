require 'rails_helper'

describe 'Answers API' do
  let!(:user)         { create(:user) }
  let!(:question)     { create(:question, user: user) }
  let(:access_token)  { create(:access_token) }
  let(:url)           { api_v1_question_answers_path(question) }

  describe 'GET /index' do
    let!(:answers)  { create_list(:answer, 3, question: question, user: user) }
    let!(:answer)   { question.answers.first }

    context 'unauthorized' do
      it 'returns status unauthorized if access_token is not provided' do
        get url, format: :json
        expect(response).to be_unauthorized
      end

      it 'returns status unauthorized if access_token is invalid' do
        get url, format: :json, access_token: SecureRandom.hex
        expect(response).to be_unauthorized
      end
    end

    context 'authorized' do
      before { get url, format: :json, access_token: access_token.token }

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
  end

  describe 'GET /show' do
    let(:answer)     { create(:answer, question: question, user: user) }
    let(:answer_url) { api_v1_answer_path(answer) }

    context 'unauthorized' do
      it 'returns status unauthorized if access_token is not provided' do
        get answer_url, format: :json
        expect(response).to be_unauthorized
      end

      it 'returns status unauthorized if access_token is invalid' do
        get answer_url, format: :json, access_token: SecureRandom.hex
        expect(response).to be_unauthorized
      end
    end

    context 'authorized' do
      let!(:comment)    { create(:comment, commentable: answer) }
      let!(:attachment) { create(:attachment, attachable: answer) }

      before { get answer_url, format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/attachments")
        end

        it 'contains url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json). at_path("answer/attachments/0/url")
        end
      end
    end
  end

  describe 'POST /create' do
    let(:question)   { create(:question, user: user) }
    let(:answer)     { build(:answer, user: user) }
    let(:owner_user) { User.find(access_token.resource_owner_id) }
    
    context 'unauthorized' do
      it 'returns status unauthorized if access_token is not provided' do
        post url, format: :json, answer: attributes_for(:answer)
        expect(response).to be_unauthorized
      end

      it 'returns status unauthorized if access_token is invalid' do
        post url, format: :json, access_token: SecureRandom.hex, question: attributes_for(:question)
        expect(response).to be_unauthorized
      end
    end

    context 'authorized' do
      context 'with valid attributes' do
        it 'returns 201 status code' do
          post url, format: :json, access_token: access_token.token, answer: attributes_for(:answer)
          expect(response.status).to eq 201
        end

        it 'saves the new answer to database' do
          expect { post url, format: :json, access_token: access_token.token, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
        end

        it 'assign new answer to current user' do
          post url, format: :json, access_token: access_token.token, answer: attributes_for(:answer)
          expect(assigns(:answer).user).to eq(owner_user)
        end
      end

      context 'with invalid attributes' do
        it 'returns 422 status code' do
          post url, format: :json, access_token: access_token.token, answer: attributes_for(:invalid_answer)
          expect(response.status).to eq 422
        end

        it 'not saves the new answer to database' do
          expect { post url, format: :json, access_token: access_token.token, answer: attributes_for(:invalid_answer) }
            .to_not change(question.answers, :count)
        end
      end
    end
  end
end