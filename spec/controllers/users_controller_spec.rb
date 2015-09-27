require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:users) { create_list(:user, 3) }

  # describe "GET #show" do
  #   it "returns http success" do
  #     get :show
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  describe "GET #index" do
    it 'populates an array of all questions' do
      get :index

      expect(assigns(:users)).to match_array(users)
    end
  end

end
