Ring::Application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' }
  devise_scope :user do
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end

  #match '/users/:id' => 'users#show', :as => :show
  resources :users, :only => [ :index, :show ] do
    member do
#      get 'fingers'
#      post 'fingers' => 'users#update_fingers'
    end

    resources :fingers, :only => [ :index, :show, :update ]
  end
  #resources :fingers, :only => [ :index, :show, :update ]

#  match '/about', :to => 'pages#about'
#  match '/contact', :to => 'pages#contact'
#  match '/help', :to => 'pages#help'

  root :to => 'pages#index'

  match '/error', :to => 'pages#error', :as => 'error'
  #handling people who give us invalid routes
  match '*a', :to => 'pages#error'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
