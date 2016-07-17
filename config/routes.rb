Rails.application.routes.draw do
  resources :users, only: [:index, :show]
  get '/seo', controller: :seo, action: :content
end
