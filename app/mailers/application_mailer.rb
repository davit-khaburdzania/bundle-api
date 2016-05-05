class ApplicationMailer < ActionMailer::Base
  default from: ENV['BUNDLE_MAIL_FROM']
end
