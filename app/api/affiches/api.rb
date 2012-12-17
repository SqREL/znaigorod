# encoding: utf-8

module Affiches
  module Entities
    class Affiche < Grape::Entity
      expose (:title)       { |model, options| model.title.gsub(/\u00AD+/,'') }
      expose (:date)        { |model, options| model.human_when.gsub(/\u00AD+/,'') }
      expose (:price)       { |model, options| model.human_price.gsub(/\u00AD+/,'') }
      expose (:place)       { |model, options| model.place.gsub(/\u00AD+/,'') }
      expose (:kind)        { |model, options| model.human_kind.gsub(/\u00AD+/,'') }
      expose (:url)         { |model, options| model.kind_affiche_url :host => Settings['app.host']}
      expose (:poster_url)  { |model, options| model.resized_poster_url(290, 390, true) }
    end
  end

  class API < Grape::API
    prefix 'api'
    format :json

    resource :popular do
      get do
        present AfficheCollection.new("kind"=>"affiches", "period"=>"all", "list_settings" => '{ "presentation": "3dtour" }').affiches, :with => Entities::Affiche
      end
    end
  end
end
