Znaigorod::Application.routes.draw do
  namespace :manage do
    post 'red_cloth' => 'red_cloth#show'

    Affiche.descendants.each do |type|
      resources type.name.underscore.pluralize
    end

    resources :search, :only => :index

    resources :affiches do
      resources :attachments, :only => [:new, :create, :destroy]
      resources :images, :only => [:new, :create, :destroy]
    end

    resources :organizations do
      resource :culture
      resource :entertainment
      resource :meal

      resources :attachments, :only => [:new, :create, :destroy]
      resources :images, :only => [:new, :create, :destroy]
      resources :organizations, :only => [:new, :create, :destroy]
    end

    root :to => 'organizations#index'
  end

  get 'search' => 'search#search', :as => :search
  get 'search/affiches', :as => :search_affiches
  get 'search/organizations', :as => :search_organizations


  get 'geocoder' => 'geocoder#get_coordinates'

  get ':kind/:period/(:on)/(categories/*categories)/(tags/*tags)' => 'affiches#index',
      :kind => /movies|concerts|parties|spectacles|exhibitions|sportsevents|others|affiches/,
      :period => /today|weekly|weekend|all|daily/, :as => :affiches

  Affiche.descendants.each do |type|
    get "#{type.name.downcase}/:id" => 'affiches#show', :as => "#{type.name.downcase}"
    get "#{type.name.downcase}/:id/photogallery" => 'affiches#photogallery', :as => "#{type.name.downcase}_photogallery"
    get "#{type.name.downcase}/:id/trailer" => 'affiches#trailer', :as => "#{type.name.downcase}_trailer"
  end

  resources :organizations, :only => :show

  get ':organization_class/(:category)/(*query)' => 'organizations#index',
      :organization_class => /organizations|meals|entertainments|cultures/, :as => :organizations
  get 'ajax/organizations/:id/photogallery' => 'organizations#photogallery', :as => :organization_photogallery
  get 'ajax/organizations/:id/affiche' => 'organizations#affiche', :as => :organization_affiche

  root :to => 'application#main_page'

  mount ElVfsClient::Engine => '/'
end
