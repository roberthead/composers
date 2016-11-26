Rails.application.routes.draw do
  resources :composers
  root to: 'home#show'
end
