class TokensController < ApplicationController
  before_filter :require_authentication
  before_filter :require_auth_code, :only => :create

  def new
    redirect_to Highrise::Token.authorize_url
  end

  def create
    if current_user.tokens.create_from_auth_code(auth_code)
      redirect_to edit_account_path, :notice => t("token.create.success")
    else
      redirect_with_error_message
    end
  end

  private

  def auth_code
    params[:code].presence
  end

  def require_auth_code
    unless auth_code
      redirect_with_error_message
    end
  end

  def redirect_with_error_message
    redirect_to edit_account_path, :alert => t("token.create.error")
  end
end
