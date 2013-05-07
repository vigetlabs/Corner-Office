class DealsController < ApplicationController
  before_filter :require_authentication
  before_filter :require_oauth_token
  before_filter :set_oauth_token
  before_filter :load_deal, :only => [:show, :edit, :update]

  def index
    @deals = Deal.find(:all)
  end

  def show
  end

  def edit
  end

  def update
    if @deal.update_deal_data(params[:deal])
      redirect_to deal_path(@deal), :notice => t("deal.update.success")
    else
      flash.now[:error] = t("deal.update.error")
      render "edit"
    end
  end

  private

  def require_oauth_token
    unless current_user.token.present?
      redirect_to edit_account_path, :alert => t("token.required")
    end
  end

  def set_oauth_token
    Highrise::Base.oauth_token = current_user.token.secret
  end

  def load_deal
    @deal ||= Deal.find(params[:id])
  end
end
