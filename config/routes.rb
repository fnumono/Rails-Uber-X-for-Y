Rails.application.routes.draw do 
  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/sidekiq' 
  apipie
  devise_for :admins, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  mount_devise_token_auth_for 'Client', at: 'api/v1/auth'
  mount_devise_token_auth_for 'Provider', at: 'api/v1/provider_auth'
  as :provider do
    # Define routes for Provider within this block.
    # get 'test' => 'base#test'
  end

  namespace :api, defaults: { format: :json }  do
    namespace :v1 do
      #####################################################
      ###   never use this followed routing style .
      ###   use route above
      # mount_devise_token_auth_for 'Client', at: 'auth'  
      #####################################################
      scope ':agent' do
        get 'setting' => 'setting#index'
        put 'setting' => 'setting#update'
        get 'types' => 'types#index'
        put 'types' => 'types#update'
        get 'alltypes' => 'types#alltypes'
        get 'zoomoffices' => 'zoom_offices#index'
        get 'tasks/mytasks' => 'tasks#index_mytasks'
        get 'tasks/mytaskscalendar' => 'tasks#index_mytasks_calendar'
        get 'tasks/summary' => 'tasks#summary'
        post 'tasks/:id/upload' => 'tasks#upload'
        put 'tasks/:id/accept' => 'tasks#accept'
        put 'tasks/:id/complete' => 'tasks#complete'
        post 'tasks/upload_files' => 'tasks#upload_files'
        resources :tasks
        resources :payments, only: :index        
        get 'escrowhours' => 'escrow_hours#show'
        get 'escrowhours/fee' => 'escrow_hours#fee'
        get 'escrowhours/coupon_check' => 'escrow_hours#coupon_check'
        post 'escrowhours/charge' => 'escrow_hours#charge'
        get 'my_notification' => 'notifications#my_notification'
        resource :client_setting, only: [:show, :update]
      end

      get 'all_types' => 'base#all_job_types'
      get 'server_setting' => 'server_settings#show'
      resources :contacts, only: :create
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
