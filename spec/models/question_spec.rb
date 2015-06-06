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

  describe '#subscribe_author' do
    let(:user) { create(:user) }
    subject    { build(:question, user: user) }
    
    it 'adds user to subscribers after create' do
      expect(subject).to receive(:subscribe).with(subject.user)
      subject.save!
    end
  end
end
