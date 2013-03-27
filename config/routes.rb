Stui::Application.routes.draw do

  root to: 'pages#home'

  match 'photos' => 'pioneers#photos'
  match 'vectors' => 'pioneers#vectors'
  match 'illustrations' => 'pioneers#illustrations'

  # vote
  match 'pioneers/:id/vote_up' => 'pioneers#vote_up', :as => :vote_up
  match 'pioneers/:id/vote_down' => 'pioneers#vote_down', :as => :vote_down

  resources :pioneers

  resources :articles do
    resources :comments
  end

  devise_for :users
  resources :users do
    member do
      put :update_pass
    end
  end


  # Admin panel

  match 'admin' => redirect('/admin/users')
  namespace :admin do
    resources :users
    resources :articles
    resources :pioneers
  end

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
  # root :to => redirect("/users/sign_in")

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
