class ApplicationController < ActionController::Base
  include SimplestAuth::Controller
  protect_from_forgery

  unless Rails.env.development?
    rescue_from ActiveRecord::RecordNotFound, ActionView::MissingTemplate,
      :with => :render_404
  end
  
  def render_404
    render :template => 'shared/404', :formats => [:html], :status => 404
  end

  private

  def require_authentication
    unless logged_in? && current_user
      redirect_to login_path, :alert => t("session.required")
    end
  end
end
