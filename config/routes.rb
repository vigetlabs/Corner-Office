CornerOffice::Application.routes.draw do
  resource :account, :controller => :users, :only => [:new, :create, :edit, :update] do
    resource :password, :only => [:edit]
  end

  match "/login" => "sessions#new", :as => "login"

  get "/authorize" => "tokens#create", :as => "authorize"

  resource :session, :only => [:new, :create, :destroy]
  resource :token, :only => [:new]
  resources :deals, :only => [:show, :edit, :update]
  resource :password, :only => [:new, :create]

  root :to => "deals#index"

  # need this because Rails `rescue_from` doesn't catch ActionController::RoutingError
  unless Rails.env.development?
    match '*path',  :to => 'application#render_404'
  end
end
