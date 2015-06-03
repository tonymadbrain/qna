require 'rails_helper'

RSpec.describe 'Profile API' do
  describe 'GET #index' do
    it_behaves_like 'API unauthorized'

    context 'authorized' do
      let!(:me) { create :user }
      let!(:users) { create_list :user, 3 }
      let(:access_token) { create :access_token, resource_owner_id: me.id }

      before { do_request access_token: access_token.token }

      it 'returns status ok' do
        expect(response).to be_success
      end

      it 'returns list of users except resource owner' do
        expect(response.body).to be_json_eql(users.to_json).at_path("profiles")
        expect(response.body).to_not include_json(me.to_json).at_path("profiles")
      end
    end

    def do_request(options = {})
      get api_v1_profiles_path, { format: :json }.merge(options)  
    end
  end

  describe 'GET #me' do
    it_behaves_like 'API unauthorized'

    context 'authorized' do
      let(:me) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: me.id }

      before { do_request access_token: access_token.token }

      it 'returns status ok' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{ attr }" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{ attr }" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    def do_request(options = {})
      # me_api_v1_profiles doesnot work ???
      # get me_api_v1_profiles, { format: :json }.merge(options)  
      get '/api/v1/profiles/me', { format: :json }.merge(options)  
    end
  end
end