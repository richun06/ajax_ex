Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index, :show]
  resources :relationships, only: [:create, :destroy]

  root 'blogs#index'
  resources :blogs do
    resources :comments
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
