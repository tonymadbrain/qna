FactoryGirl.define do
  factory :comment do
    body "Super comment"
    association :commentable, factory: :question
    user
  end

  factory :invalid_comment, class: 'Comment' do
    body nil
  end

end
