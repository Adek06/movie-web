Rails.application.routes.draw do
  resources :seasons
  resources :shows
  resources :videos
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
