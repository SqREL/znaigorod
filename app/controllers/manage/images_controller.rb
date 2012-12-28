class Manage::ImagesController < Manage::ApplicationController
  actions :new, :create, :destroy, :update, :edit

  belongs_to :culture, :entertainment, :meal, :sauna, :sport, :billiard, :creation,
    :polymorphic => true, :optional => true

  belongs_to :affiche, :organization, :sauna_hall,
    :polymorphic => true, :optional => true

  def create
    create! { collection_path }
  end

  def update
    update! { collection_path }
  end

  def destroy
    destroy! { collection_path }
  end

  protected
    def collection_path
      case parent
      when Affiche
        manage_affiche_path(parent)
      when Organization
        manage_organization_path(parent)
      when SaunaHall
        manage_organization_sauna_sauna_hall_path(@organization, parent)
      when Culture, Entertainment, Meal, Sauna, Sport, Billiard, Creation
        manage_organization_path(parent.organization)
      end
    end
end
