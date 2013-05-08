class DealsController < ApplicationController
  helper_method :deal, :deals, :deals_missing_data

  before_filter :require_authentication
  before_filter :require_oauth_token

  def index
    @chart = Visualization::DealsByMonthChart.new(deals,
                              :start_date => Date.today.at_beginning_of_year,
                              :end_date => 3.years.from_now,
                              :title => "Projects by Month (Budget/Project Duration)")
  end

  def show
    @chart = Visualization::DealsByMonthChart.new([deal],
                              :start_date => Date.today.at_beginning_of_year,
                              :end_date => 3.years.from_now,
                              :title => "Project Timeline",
                              :legend => "none")
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

  def deals
    @deals ||= all_deals - deals_missing_data
  end

  def all_deals
    @all_deals ||= Deal.find(:all, :params => { :status => "pending" })
  end

  def deals_missing_data
    @deals_missing_data ||= Deal.filter(:missing_data, all_deals)
  end
end
