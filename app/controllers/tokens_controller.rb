class TokensController < ApplicationController
  before_filter :require_authentication
  before_filter :require_auth_code, :only => :create

  def new
    redirect_to Highrise::Token.authorize_url
  end

  def create
    if new_token_from_auth_code.save
      current_user.set_default_site
      redirect_to edit_account_path, :notice => t("token.create.success")
    else
      redirect_with_error_message
    end
  end

  private

  def new_token_from_auth_code
    current_user.tokens.new_from_auth_code(auth_code)
  end

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
