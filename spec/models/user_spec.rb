require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:identitys).dependent(:destroy) }

  describe '.find_for_oauth' do
    context "when user is unregistered" do
      let(:user) { build(:user) }
      let(:auth) do
        OmniAuth::AuthHash.new({
          provider: 'provider',
          uid: '12345',
          info: {
            email: user.email
          }
        })
      end
      let(:create_find_for_oauth) { User.find_for_oauth(auth) }
      
      it 'creates user' do
        create_find_for_oauth
        expect(User.find_by(email: user.email)).to_not be_nil
      end

      it "increments user's count" do
        expect { create_find_for_oauth }.to change(User, :count).by(1)
      end

      it 'creates identity for created user' do
        create_find_for_oauth
        expect(Identity.find_by(uid: auth.uid, provider: auth.provider).user.email).to eq user.email
      end
    end

    context 'when user is registered' do
      let!(:user) { create(:user) }
      let(:auth) do
        OmniAuth::AuthHash.new({
          provider: 'provider',
          uid: '12345',
          info: {
            email: user.email
          }
        })
      end
      let(:find_find_for_oauth) { User.find_for_oauth(auth) }
      
      it 'finds user' do
        expect(find_find_for_oauth).to eq user
      end

      it "doesn't increment user's count" do
        expect { find_find_for_oauth }.to_not change(User, :count)
      end

      context "when identity doesn't exist" do
        it 'creates new identity for given user' do
          expect { find_find_for_oauth }.to change(user.identitys, :count).by(1)
        end
      end

      context "when identity exists" do
        before { create(:identity, user: user, uid: auth.uid, provider: auth.provider) }
        it "doesn't create new identity" do
          expect { find_find_for_oauth }.to_not change(user.identitys, :count)
        end
      end
    end
  end

  describe '.send_daily_digest' do
    let(:users) { create_list(:user, 2) }

    it 'should send daily digest to all users' do
      users.each { |user| expect(DailyMailer).to receive(:digest).with(user).and_call_original }
      User.send_daily_digest
    end
  end
end
