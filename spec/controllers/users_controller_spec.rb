require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:users) { create_list(:user, 3) }
  let(:user) { users[0] }

  describe 'GET #index' do
    before { get :index }

    it 'populates an array of all users' do
      expect(assigns(:users)).to match_array(users)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: user }

    it 'assigns users to @user' do
      expect(assigns(:user)).to eq user
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end
end
