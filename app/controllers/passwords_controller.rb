class PasswordsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(user_params[:email])
    if user
      user.send_password_reset_instructions
      redirect_to login_path, :notice => t("password.create.success")
    else
      redirect_to new_password_path, :alert => t("password.create.error")
    end
  end

  def edit
    @user = User.find_by_password_reset_token(params[:token]) if params[:token].present?
    if @user
      self.current_user = @user
    else
      redirect_to new_password_path, :alert => t("password.edit.error")
    end
  end

  private

  def user_params
    params[:user] || {}
  end
end