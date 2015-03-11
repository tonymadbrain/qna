require 'rails_helper'

RSpec.describe Question, type: :model do

  describe "validations and relationships" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
    it { should have_many :answers }
  end

  describe "destroy questions" do
    it "should destroy dependent answers" do
      question = FactoryGirl.create(:question)
      answer_1 = FactoryGirl.create(:answer, question_id: question.id)
      answer_2 = FactoryGirl.create(:answer, question_id: question.id)
      answer_3 = FactoryGirl.create(:answer, question_id: question.id)

      expect { question.destroy! }.to change{ Answer.count }.by(-3)
    end
  end

end
