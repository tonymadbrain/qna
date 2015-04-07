require 'rails_helper'

RSpec.describe Answer, type: :model do

  it { should validate_presence_of :body }
  it { should validate_presence_of :user }
  it { should belong_to(:question) }

  describe 'Make answer best' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }
    let(:another_answer) { create(:answer, user: user, question: question) }

    it 'it work' do
      expect{ answer.make_best }.to change(answer, :best).from(false).to(true)
    end

    it 'it not switch off best status for answer' do
      answer.make_best
      answer.make_best
      expect(answer.best).to eq true
    end

    it 'makes only one best answer per question' do
      answer.make_best
      another_answer.make_best

      answer.reload      
      another_answer.reload      

      expect(answer.best).to eq false
      expect(another_answer.best).to eq true
    end
  end

end
