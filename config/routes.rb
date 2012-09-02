Geocanvas::Application.routes.draw do
  resource :map, :only => [:show]
  resources :polygons

  root :to => 'map#show'
end
