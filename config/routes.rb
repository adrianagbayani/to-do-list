Rails.application.routes.draw do
	#root to: "index#index"

  api vendor_string: "list", default_version: 1, path: '' do
    version 1 do
      cache as: 'v1' do
        post "users/sign_in" => 'sessions#create'
        post "users/sign_out" => 'sessions#destroy'
        post "users" => 'registrations#create'

        resources :task_lists, only: [:index, :create, :update, :destroy, :show] do
          resources :tasks, only: [:create, :update, :destroy, :show] do
						resources :notes, only: [:create, :update, :destroy]

						member do
							post 'complete'
						end
          end
        end
      end
    end
  end

  root :to => "application#index"
  get "*path" => "application#index"

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
