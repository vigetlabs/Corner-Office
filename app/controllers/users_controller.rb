class UsersController < ApplicationController
  before_filter :require_authentication, :only => [:edit, :update]

  helper_method :highrise_sites

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      self.current_user = @user
      redirect_to edit_account_path, :notice => t("user.create.success")
    else
      flash.now[:error] = t("user.create.error")
      render "new"
    end
  end

  def edit
  end

  def update
    if current_user.update_attributes(params[:user])
      redirect_to edit_account_path, :notice => t("user.update.success")
    else
      flash.now[:error] = t("user.update.error")
      render "edit"
    end
  end

  private

  def highrise_sites
    @highrise_sites ||= current_user.try(:highrise_sites)
  end
end
