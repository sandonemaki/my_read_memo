class ChangeColumnToRandokuImgs < ActiveRecord::Migration[6.1]
  def change
    change_column_null :randoku_imgs, :thumbnail_path, false
  end
end
