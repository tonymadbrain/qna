# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create admin and user

pw_123 = "qwerty12345"
User.create(email: "admin@qna.dev", password: pw_123, password_confirmation: pw_123, admin: true)

["user@qna.dev", "another_user@qna.dev"].each do |e_mail|
  User.create(email: e_mail, password: pw_123, password_confirmation: pw_123, admin: false)
end

# # Test questions

# 10.times do |q|
#   q = q + 1
#   Question.create(id: "#{q}", title: "Question #{q} about some things?", body: "Does'not metter what I am asking. Metter what is the ask they give for me!", user_id: 2)
# end

# Question.create(id: 11, title: "This question have the answers", body: "Realy look at the bottom", user_id: 2)
# # Question.create(id: 12, title: "This question have the comments", body: "Realy look at the bottom", user_id: 2)

# # Test answers

# 3.times do |a|
#   a = a + 1
#   Answer.create(id: "#{a}", body: "Right answer #{a} for your question, ask more!", question_id: 11, user_id: 3)
# end










