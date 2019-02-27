class UserMailer < ApplicationMailer
  default from: ENV['EMAIL_USERNAME']

	def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Security Igloo')
  end

  def password_reset(user)
    @user = user
    mail(to: user.email, subject: 'Password reset')
  end
end
