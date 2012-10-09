class CreateVkTokens < ActiveRecord::Migration
  def change
    create_table :vk_tokens do |t|
      t.string  :token
      t.integer :expires_in
      t.boolean :active

      t.timestamps
    end
  end
end
