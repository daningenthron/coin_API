Rails.application.routes.draw do
  scope '/api' do
    resources :coins do
      get 'total', :on => collection
    end
  end
end 
