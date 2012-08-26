Geocanvas::Application.routes.draw do
  resource :map, :only => [:show]

  root :to => 'map#show'
end
