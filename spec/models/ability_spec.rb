require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user)              { create :user }
    let(:other)             { create :user }
    let(:question)          { create :question, user: user }
    let(:other_question)    { create :question, user: other }
    let(:answer)            { create :answer, user: user, question: question }
    let(:other_answer)      { create :answer, user: other, question: other_question }
    let(:attachment)        { create :attachment, attachable: question }
    let(:other_attachment)  { create :attachment, attachable: other_question }


    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question, user: user }
    it { should_not be_able_to :update, other_question, user: user }

    it { should be_able_to :update, answer, user: user }
    it { should_not be_able_to :update, other_answer, user: user }

    it { should be_able_to :destroy, question, user: user }
    it { should_not be_able_to :destroy, other_question, user: user }

    it { should be_able_to :destroy, answer, user: user }
    it { should_not be_able_to :destroy, other_answer, user: user }

    it { should be_able_to :destroy, attachment, user: user }
    it { should_not be_able_to :destroy, other_attachment, user: user }

    it { should be_able_to :make_best, answer, user: user }
    it { should_not be_able_to :make_best, other_answer, user: user }

    it { should be_able_to :subscribe, question }
    it { should be_able_to :unsubscribe, question }

    it { should_not be_able_to :create_vote, question, user: user }
    it { should_not be_able_to :create_vote, answer, user: user }
    it { should_not be_able_to :delete_vote, question, user: user }
    it { should_not be_able_to :delete_vote, answer, user: user }
    it { should be_able_to :create_vote, other_question, user: user }
    it { should be_able_to :create_vote, other_answer, user: user }
  end
end