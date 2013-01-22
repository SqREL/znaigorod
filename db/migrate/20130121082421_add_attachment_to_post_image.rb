class AddAttachmentToPostImage < ActiveRecord::Migration
  def change
    add_attachment :post_images, :attachment
  end
end
