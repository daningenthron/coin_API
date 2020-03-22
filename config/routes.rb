Rails.application.routes.draw do
  resources :coins do
    get 'total', :on => :collection
  end
end
