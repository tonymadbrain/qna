FactoryGirl.define do

  factory :question do
    title 'Super title'
    body 'Super text'
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
