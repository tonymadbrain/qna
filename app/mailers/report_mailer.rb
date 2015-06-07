class ReportMailer < ApplicationMailer
  def report(user, answer)
    @user   = user 
    @answer = answer

    mail(to: user.email, subject: 'New answer')
  end
end
