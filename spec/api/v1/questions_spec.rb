require 'rails_helper'

describe 'Questions API' do
  let(:access_token) { create(:access_token) }
  let(:user)         { create(:user) }
  let(:url)          { api_v1_questions_path }

  describe 'GET /index' do
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
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question)   { questions.first }
      let!(:answer)    { create(:answer, question: question, user: user) }

      before { get url, format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

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
  end

  describe 'GET /show' do
    let!(:question)    { create(:question, user: user) }
    let(:question_url) { api_v1_question_path(question) }

    context 'unauthorized' do
      it 'returns status unauthorized if access_token is not provided' do
        get question_url, format: :json
        expect(response).to be_unauthorized
      end

      it 'returns status unauthorized if access_token is invalid' do
        get question_url, format: :json, access_token: SecureRandom.hex
        expect(response).to be_unauthorized
      end
    end

    context 'authorized' do
      let!(:comment)    { create(:comment, commentable: question) }
      let!(:attachment) { create(:attachment, attachable: question) }

      before { get question_url, format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("question/comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("question/attachments")
        end

        it 'contains url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json). at_path("question/attachments/0/url")
        end
      end
    end
  end

  describe 'POST /create' do
    let(:question) { build(:question) }
    let(:owner_user) { User.find(access_token.resource_owner_id) }

    context 'unauthorized' do
      it 'returns status unauthorized if access_token is not provided' do
        post url, format: :json, question: attributes_for(:question)
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
          post url, format: :json, access_token: access_token.token, question: attributes_for(:question)
          expect(response.status).to eq 201
        end

        it 'saves the new question to database' do
          expect { post url, format: :json, access_token: access_token.token, question: attributes_for(:question) }.to change(Question, :count).by(1)
        end

        it 'assign new question to current user' do
          post url, format: :json, access_token: access_token.token, question: attributes_for(:question)
          expect(assigns(:question).user).to eq(owner_user)
        end
      end

      context 'with invalid attributes' do
        it 'returns 422 status code' do
          post url, format: :json, access_token: access_token.token, question: attributes_for(:invalid_question)
          expect(response.status).to eq 422
        end

        it 'not saves the new question to database' do
          expect { post url, format: :json, access_token: access_token.token, question: attributes_for(:invalid_question) }
            .to_not change(Question, :count)
        end
      end
    end
  end
end