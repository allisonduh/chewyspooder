Rails.application.routes.draw do
  #scope '/api' do
  #	resources :products, only: [:index]
  #end

  root 'products#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  
end