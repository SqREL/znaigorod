class CreateOrganizationStands < ActiveRecord::Migration
  def change
    create_table :organization_stands do |t|
      t.references :organization
      t.integer :places
      t.integer :guarded
      t.integer :video_observation

      t.timestamps
    end
    add_index :organization_stands, :organization_id
  end
end
