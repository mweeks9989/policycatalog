Policycatalog::Application.routes.draw do
  namespace :api, except: [:edit, :new] do
    namespace :v1 do
      resources :sites,      format: 'json', id: /[^\/]+/,
                             only:   [ :show, :index, :create, :destroy ]

      resources :categories, format: 'json',
                             only:   [ :show, :index ] do
        resources :sites, id:   /[^\/]+/ do
          put '' => 'sites#categorize'
          delete '' => 'sites#uncategorize'
        end
      end

      resources :policies,   format: 'txt', 
                             only: [ :show ]
    end
  end

  # legacy route
  get  '/policies/:name' => 'api/v1/policies#show'
end
