class CreateContests < ActiveRecord::Migration
  def change
    create_table :contests do |t|
      t.string :title
      t.text :description
      t.date :starts_on
      t.date :ends_on

      t.timestamps
    end
  end
end
