Rails.application.routes.draw do
  root to: 'home#index'

  resources :sessions do
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
