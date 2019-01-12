Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "pages#home"
  get '/about', to: 'pages#about'
  get '/help', to: 'pages#help'
  
  resources :todos
  get '/signup', to: 'users#new'
  resources :users, except: [:new]
  
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
