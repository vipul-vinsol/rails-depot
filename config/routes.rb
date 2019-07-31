Rails.application.routes.draw do
  get 'admin' => 'admin#index'
  get 'users/orders', to: 'users#show_user_orders'
  get 'users/line_items', to: 'users#show_user_line_items'
  controller :sessions do
    get  'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :users
  resources :products do
    get :who_bought, on: :member
  end

  scope '(:locale)' do
    resources :orders
    resources :line_items
    resources :carts
    root 'store#index', as: 'store_index', via: :all
  end
end