class ReportMailer < ApplicationMailer
  def report(user, answer)
    @answer = answer

    mail to: user.email
  end
end
