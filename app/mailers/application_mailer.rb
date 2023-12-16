# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'zen-counselling@gmail.com'
  layout 'mailer'
end
