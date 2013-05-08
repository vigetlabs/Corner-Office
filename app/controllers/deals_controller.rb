class DealsController < ApplicationController
  helper_method :deal

  before_filter :require_authentication
  before_filter :require_oauth_token

  def index
    @deals = Deal.find(:all)
  end

  def show
  end

  def edit
  end

  def update
    if deal.update_deal_data(params[:deal])
      redirect_to deal_path(deal), :notice => t("deal.update.success")
    else
      flash.now[:error] = t("deal.update.error")
      render "edit"
    end
  end

  private

  def require_oauth_token
    if current_user.token.present?
      Highrise::Base.oauth_token = current_user.token.secret
    else
      redirect_to edit_account_path, :alert => t("token.required")
    end
  end

  def deal
    @deal ||= Deal.find(params[:id])
  end
end
