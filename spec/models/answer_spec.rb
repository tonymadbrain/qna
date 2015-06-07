require 'rails_helper'

RSpec.describe Answer, type: :model do

  it { should belong_to(:question) }
  it { should validate_presence_of :body and :user }
  it { should have_many(:comments).dependent(:destroy) }

  describe 'Make answer best' do
    let(:user)      { create(:user) }
    let(:question)  { create(:question, user: user) }
    let(:answer)    { create(:answer, user: user, question: question) }

    it 'it work' do
      expect{ answer.make_best }.to change(answer, :best).from(false).to(true)
    end

    it 'it not switch off best status for answer' do
      answer.make_best
      answer.make_best
      expect(answer.best).to eq true
    end

    it 'makes only one best answer per question' do
      answer_2 = create(:answer, user: user, question: question, best: true)
      answer.make_best

      answer.reload
      answer_2.reload

      expect(answer.best).to eq true
      expect(answer_2.best).to eq false
    end
  end
  
  it_behaves_like 'votable'
  it_behaves_like 'attachable'

  describe '#report_to_subscribers', :focus do
    let(:user)     { create(:user) }
    let(:question) { create(:question, user: user) }
    subject        { build(:answer, user: user, question: question) }

    it 'send email to question subscribers' do
      subject.question.subscribers.each { |user| expect(ReportMailer).to receive(:report).with(user, subject).and_call_original }
      subject.save!
    end
  end
end
