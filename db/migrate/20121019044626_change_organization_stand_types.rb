class ChangeOrganizationStandTypes < ActiveRecord::Migration
  def up
    drop_table :organization_stands

    create_table :organization_stands do |t|
      t.references :organization
      t.integer :places
      t.boolean :guarded
      t.boolean :video_observation

      t.timestamps
    end
    add_index :organization_stands, :organization_id
  end

  def down
    drop_table :organization_stands

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
