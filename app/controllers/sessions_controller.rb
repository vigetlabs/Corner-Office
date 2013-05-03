class SessionsController < ApplicationController
  before_filter :require_authentication, :only => [:destroy]
  before_filter :require_no_authentication, :only => [:new, :create]

  def new
  end

  def create
    if user = User.authenticate(session_params[:email], session_params[:password])
      self.current_user = user
      redirect_to edit_account_path, :notice => t("session.create.success")
    else
      flash.now[:error] = t("session.create.error")
      render "new"
    end
  end

  def destroy
    self.current_user = nil
    redirect_to login_path, :notice => t("session.destroy.success")
  end

  private

  def require_no_authentication
    if logged_in? && current_user
      redirect_to edit_account_path
    end
  end

  def session_params
    params[:session] || {}
  end
end
