Inz::Application.routes.draw do

  #DEFAULT
  resources :auctions, :only => [:index, :show] do
    resources :ratings, :only => [:index, :create]
    get :result, :on => :collection
    get :search, :on => :collection
  end
  
  #Users and sessions
  resources :users do
  	member do
  		get :watching, :watchers
  	end
  	resources :userprojects, :only => [:index]
  	resources :blogposts do
  		member do
  			get :admin
  		end
  	end
  	resources :portfolios
  	resources :bonuspoints, :only => [:index] do
  		member do
  			get :addfromblog
  		end
  	end
  end
  resources :sessions, :only => [:new, :create, :destroy]
  resources :relationships, :only => [:create, :destroy]
  resources :blogposts
  resources :blogcomments
  resources :bonuspoints
  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match 'signout',  :to => 'sessions#destroy'
  match '/ver', :to => 'users#mail_ver'
  match '/find', :to => 'users#find'
  match '/delete', :to => 'users#delete'

  # PANEL
  namespace :panel do
    
    resources :auctions, :except => [:show] do
      resources :communications, :only => [:new, :create]
      get :offers, :on => :member # offers#index dla wlasnych ofert zarezerwowane
      resources :offers, :only => [:destroy, :new, :create] do
        #get :to_reject, :on => :member
      end
      #resources :alerts, :only => [:index, :show] do
      #  member do
      #    get :reject_offer
      #  end
      #end
    end
    
    resources :offers, :only => [:index] do
      post :to_reject, :on => :member
    end
    resources :comments do
      get :queue, :on => :collection
    end
    resources :messages, :except => [:edit, :update] do
      get :reply, :on => :member
      get :sent, :on => :collection
    end
    
    resources :projects, :only => :index
  end

  #ADMIN
  namespace :admin do
    resources :auctions, :except => [:show] do
      resources :offers, :only => [:destroy] do
        get :recovery, :on => :member
      end
    end
    resources :messages, :except => [:edit, :update] do
      get :reply, :on => :member
      get :sent, :on => :collection
    end
    resources :groups, :except => [:show]
    resources :tags, :except => [:show]
    resources :communications, :only => [:destroy]
    resources :users do
    	get :blogposts, :on => :member
      resources :comments, :only => [:index, :edit, :update]
    end
  end
  match 'admin/users/:id/points', :to => 'admin/users#points'
  match 'admin/users/:id/editpoints', :to => 'admin/users#editpoints'
  match 'admin/users/:id/status/:status/delete', :to => 'admin/users#delete'
  match 'admin/blogposts', :to => 'admin/users#blogposts'
  match 'admin/blogpost/:id', :to => 'admin/users#blogpostedit'
  match 'admin/blogpost/:id/edit', :to => 'admin/users#blogpostedit2'
  match 'admin/blogposts/delete/:blogpost', :to => 'admin/users#deleteblogpost'
  
  #PROJECT
  scope :module => "project" do
    resources :projects do
      resource :info, :only => [:show, :update], :controller => "info"
      resources :members, :only => [:index, :update, :destroy]
      resources :files, :except => [:edit]
      resources :invitations, :except => [:show, :update] do
        get :accept, :on => :member
        get :reject, :on => :member
        get :cancel, :on => :member
      end
      resources :topics do
      	resources :posts, :except => [:index, :show]
      end
      resources :tickets do
        get :take, :on => :member
        get :give, :on => :member
      end
    end
  end
  	
  resources :alerts, :only => [:create]
  
  root :to =>  "auctions#index"

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
