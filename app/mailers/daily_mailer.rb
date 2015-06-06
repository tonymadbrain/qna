class DailyMailer < ApplicationMailer
  def digest(user)
    @greeting = "Hi"
    @questions = Question.created_yesterday
    mail to: user.email
  end
end
