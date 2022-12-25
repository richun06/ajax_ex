Rails.application.routes.draw do
  devise_for :users
  root 'blogs#index'
  resources :blogs do
    resources :comments
  end

  resources :users

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
