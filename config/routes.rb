Znaigorod::Application.routes.draw do
  namespace :manage do
    post 'red_cloth' => 'red_cloth#show'

    #resources :affiches, :only => [:index, :new]
    #resources :organizations, :only => [:index, :new]

    #Organization.descendants.each do |type|
      #resources type.name.underscore.pluralize, :except => :show
    #end

    Affiche.descendants.each do |type|
      resources type.name.underscore.pluralize
    end

    resources :search, :only => :index
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

  resources :affiches, :only => [:index, :show]

  resources :entertainments
  resources :meals
  resources :organizations

  root :to => 'application#main_page'

  mount ElVfsClient::Engine => '/'
end
