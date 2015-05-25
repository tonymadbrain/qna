class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.email_default_from
  layout 'mailer'
end