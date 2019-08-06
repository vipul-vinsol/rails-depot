Rails.application.routes.draw do
  # constraints user_agent: /Firefox/ do
  #   root 'store#index'
  #   #  match '*url', to: redirect('/404'), via: :all
  # end

  get 'admin' => 'admin#index'

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  scope '(:locale)' do
    get '/users/orders', to: 'users#show_user_orders'
    get '/users/line_items', to: 'users#show_user_line_items'
    get '/categories/all', to: 'categories#show_categories'
    get '/admin/report'
    get '/my-orders', to: 'users#show_user_orders'
    get '/my-items', to: 'users#show_user_line_items'
    get '/categories/:id/books', to: 'categories#show_products', id: /\d*/,
        as: 'categories_show_products'
    get '/categories/:id/books', to: redirect('/')

    namespace :admin do
      resources :reports, :categories
    end
    resources :users
    resources :orders
    resources :line_items
    resources :carts
    resources :categories
    resources :ratings
    root 'store#index', as: 'store_index', via: :all
  end

  resources :products, path: :books do
    get :who_bought, on: :member
  end
end