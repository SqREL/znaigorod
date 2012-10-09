class CreateVkTokens < ActiveRecord::Migration
  def change
    create_table :vk_tokens do |t|
      t.string :token

      t.timestamps
    end
  end
end
