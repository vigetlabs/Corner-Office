class ApplicationController < ActionController::Base
  protect_from_forgery

  unless Rails.env.development?
    rescue_from ActiveRecord::RecordNotFound, ActionView::MissingTemplate,
      :with => :render_404
  end
  
  def render_404
    render :template => 'shared/404', :formats => [:html], :status => 404
  end
end
