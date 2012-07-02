Znaigorod::Application.routes.draw do
  namespace :manage do
    #post 'red_cloth' => 'red_cloth#show'

    #resources :affiches, :only => [:index, :new]
    #resources :organizations, :only => [:index, :new]

    #Organization.descendants.each do |type|
      #resources type.name.underscore.pluralize, :except => :show
    #end

    #Affiche.descendants.each do |type|
      #resources type.name.underscore.pluralize, :except => :show
    #end

    resources :affiches
    resources :organizations do
      resources :organizations
      resource :meal
      resource :entertainment
    end

    root :to => 'organizations#index'
  end

  get 'search' => 'search#index'
  get 'geocoder' => 'geocoder#get_coordinates'

  resources :affiches, :only => [:index, :show]

  resources :entertainments
  resources :meals
  resources :organizations

  root :to => 'application#main_page'

  mount ElVfsClient::Engine => '/'
end
