class ApplicationMailer < ActionMailer::Base
  default from: "Claimore <#{ENV['GMAIL_USERNAME']}>"
  layout "mailer"
end
