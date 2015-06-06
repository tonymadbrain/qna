FactoryGirl.define do

  factory :question do
    title 'Super title'
    body 'Super text'
    user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
