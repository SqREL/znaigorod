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
      resource :entertainment
      resource :meal

      resources :attachments, :only => [:new, :create, :destroy]
      resources :images, :only => [:new, :create, :destroy]
      resources :organizations, :only => [:new, :create, :destroy]
    end

    root :to => 'organizations#index'
  end

  get 'search' => 'search#index'
  get 'geocoder' => 'geocoder#get_coordinates'

  { 'kino' => 'movies', 'vecherinki' => 'parties' }.each do |category, kind|
    get "/affiches/#{kind}" => 'affiches#index',
        :defaults => {
          :search => {
            :starts_on_gt       => Date.today.to_s,
            :starts_on_lt       => Date.today.to_s,
            :starts_at_hour_gt  => '0',
            :starts_at_hour_lt  => '23',
            :affiche_category   => ["#{category}"],
            :price_gt           => '0',
            :price_lt           => '>1500'
          }
        }
  end

  resources :affiches, :only => [:show]
  match ':kind/:period/' => 'affiches#index',
        :kind => /movies|concerts|parties|spectacles|exhibitions|sportsevents|others|affiches/,
        :period => /today|weekly|weekend|all|daily/, :as => :affiches


  resources :entertainments
  resources :meals
  resources :organizations

  root :to => 'application#main_page'

  mount ElVfsClient::Engine => '/'
end
