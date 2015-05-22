require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let!(:auth)  { OmniAuth::AuthHash.new(provider: 'facebook', uid: 'qwe123') }

    context 'user already has authoriztion' do
      it 'returns the user' do
        user.identitys.create(provider: 'facebook', uid: 'qwe123')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has no identity'do
      context 'but already exist' do
      let!(:auth)  { OmniAuth::AuthHash.new(provider: 'facebook', uid: 'qwe123', info: { email: user.email }) }
        it 'does not create new user' do
          expect{ User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates identitys for user' do
          expect{ User.find_for_oauth(auth) }.to change(user.identitys, :count).by(1)
        end

        it 'creates identitys with valid data' do
          identity = User.find_for_oauth(auth).identitys.first
          
          expect(identity.provider).to eq auth.provider
          expect(identity.uid).to eq auth.uid
        end

        it 'return the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'and does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: 'qwe123', info: { email: 'new_user@email.com' }) }
      
        it 'creates new user' do
          expect{ User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end
        
        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end
        
        it 'fils user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end
        
        it 'creates identitys for user' do
          user = User.find_for_oauth(auth)
          expect(user.identitys).to_not be_empty
        end
        
        it 'creates identitys with valid data' do
          identity = User.find_for_oauth(auth).identitys.first

          expect(identity.provider).to eq auth.provider
          expect(identity.uid).to eq auth.uid
        end
      end
    end
  end
end
