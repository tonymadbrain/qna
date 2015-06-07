require 'rails_helper'

RSpec.describe Question, type: :model do

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscribe_lists).dependent(:destroy) }
  it { should have_many(:subscribers) }
  it { should belong_to(:user) }
  it { should validate_presence_of :title and :body and :user }

  it_behaves_like 'votable'
  it_behaves_like 'attachable'

  describe 'Subscriprions' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question)     { create(:question, user: user) }    

    describe '#subscribe_author' do
      subject    { build(:question, user: user) }

      it 'adds user to subscribers after create' do
        expect(subject).to receive(:subscribe).with(subject.user)
        subject.save!
      end
    end

    describe '#subscribe' do
      it 'adds given user to subscribers' do
        expect{ question.subscribe(another_user) }.to change(question.subscribers, :count).by 1
      end

      it 'doesnt add user to subscribers if he is already there' do
        expect{ question.subscribe(question.user) }.to_not change(question.subscribers, :count)
      end
    end

    describe '#unsubscribe' do
      it 'delete given user from subscribers' do
        expect{ question.unsubscribe(user) }.to change(question.subscribers, :count).by(-1)
      end

      it 'doesnt delete user from subscribers if he is not in' do
        expect{ question.unsubscribe(another_user) }.to_not change(question.subscribers, :count)
      end
    end
  end
end
