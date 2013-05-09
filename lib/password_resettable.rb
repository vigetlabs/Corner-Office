module PasswordResettable
  extend ActiveSupport::Concern

  included do
    validates :password_reset_token, :uniqueness => true, :allow_nil => true
    before_save :unset_password_reset_token
  end

  def send_password_reset_instructions
    set_password_reset_token
    PasswordResetMailer.send_reset_instructions(self).deliver
  end

  private

  def set_password_reset_token
    self.password_reset_token = new_password_reset_token
    self.save
  end

  def new_password_reset_token
    SecureRandom.urlsafe_base64(30)
  end

  def unset_password_reset_token
    self.password_reset_token = nil unless password_reset_token_changed?
  end
end