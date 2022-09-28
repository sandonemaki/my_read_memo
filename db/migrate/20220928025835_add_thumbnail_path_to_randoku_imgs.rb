class AddThumbnailPathToRandokuImgs < ActiveRecord::Migration[6.1]
  def change
    add_column :randoku_imgs, :thumbnail_path, :string
  end
end
