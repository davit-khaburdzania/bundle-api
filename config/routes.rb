Rails.application.routes.draw do
  # Authentication
  get 'auth/:provider/callback', to: 'auth#create'
  get 'signout', to: 'auth#destroy', as: 'signout'
  get 'me', to: 'users#me'

  # Search
  get '/search/resource', to: 'search#resource'

  # Favorites
  post '/:resource/:id/favorite', to: 'favorites#favorite'
  delete '/:resource/:id/favorite', to: 'favorites#unfavorite'
  resources :favorites, only: [:index]

  # Invites
  post '/:resource/:id/invite', to: 'invites#create'
  post '/:resource/:id/invite/approve', to: 'invites#approve'

  # Share
  post '/:resource/:id/share-by-url', to: 'shares#share_by_url'

  resources :collections do
    get 'bundles', on: :member
  end

  resources :bundles
  resources :links, except: :index
end
