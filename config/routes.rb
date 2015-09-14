Rails.application.routes.draw do
  root to: 'home#index'

  get 'sessions/edit', to: 'sessions#edit', as: :edit_session
  delete 'logout', to: 'sessions#destroy', as: :destroy_session

  resources :sessions, except: [:edit, :destroy] do
  end

  resources :payments do
    collection do
      post :credit_card
      post :paypal
      get :paypal_return
      get :paypal_cancel
    end
  end
end
