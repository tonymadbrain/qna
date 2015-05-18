FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password 'qwerty123'
    password_confirmation 'qwerty123'
  end
end
