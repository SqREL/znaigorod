class AddConstantToAffiche < ActiveRecord::Migration
  def change
    add_column :affiches, :constant, :boolean
  end
end
