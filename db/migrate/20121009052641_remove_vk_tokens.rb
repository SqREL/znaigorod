class RemoveVkTokens < ActiveRecord::Migration
  def up
    drop_table :vk_tokens
  end

  def down
  end
end
