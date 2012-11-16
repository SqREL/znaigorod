class AddTypeToEntertaiment < ActiveRecord::Migration
  def change
    add_column :entertainments, :type, :string
  end
end
