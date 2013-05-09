class PasswordResetMailer < ActionMailer::Base
  def send_reset_instructions(user)
    @user = user
    mail(:to => user.email, :subject => "Password Reset Instructions")
  end
end