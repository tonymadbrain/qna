class IdentityMailer < ApplicationMailer

  def confirm_email(user, identity)
    @user = user
    @identity = identity
    mail to: user.email, subject: 'Email confirmation'
  end
end