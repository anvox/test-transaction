Rails.application.routes.draw do
  resources :jobs
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get :trans, to: 'users#trans'
  get :done, to: 'users#done'
end
