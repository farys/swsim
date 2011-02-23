Inz::Application.routes.draw do

  #DEFAULT
  resources :categories, :only => [:index, :show]

  resources :auctions, :only => [:show] do
    
    resources :ratings, :only => [:index, :create]
    resources :offers, :only => [:new, :create]
    
    collection do
      get :search
      post :result
    end
  end
  
  resources :users do
    resources :messages, :only => [:new, :create]
  end
  
  # PANEL
  namespace :panel do
    
    resources :auctions, :except => [:show] do
      resources :communications, :only => [:new, :create]
      resources :offers, :only => [:destroy]
    end
    
    resources :offers, :only => [:index] do
      member do
        post :to_reject
      end
    end
    
    resources :messages, :only => [:index, :show, :destroy] do
      member do
        get :reply
      end
      
      collection do
        get :sent
      end
    end
  end
    
  resources :alerts, :only => [:create]
  
  root :to =>  "categories#index"

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
