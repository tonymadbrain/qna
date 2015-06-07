FactoryGirl.define do

  sequence :body do |n|
    "Super answer text #{n}"
  end

  factory :answer do
    body
    question
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
