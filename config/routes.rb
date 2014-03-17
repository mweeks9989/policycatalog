Policycatalog::Application.routes.draw do
  namespace :api, except: [:edit, :new] do
    namespace :v1 do
      resources :sites,      format: 'json', id: /[^\/]+/,
                             only:   [ :show, :index, :create, :destroy ] do
                               post 'add',    on: :member
                               post 'remove', on: :member
                             end

      resources :categories, format: 'json',
                             only:   [ :show, :index ] do
                               post 'add',    on: :member
                               post 'remove', on: :member 
                            end

      resources :policies,   format: 'txt', 
                             only: [ :show ]
    end
  end

  # legacy route
  get  '/policies/:name' => 'api/v1/policies#show'
end
