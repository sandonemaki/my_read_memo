class RenameLookedFlagColumnToRandokuImgs < ActiveRecord::Migration[6.1]
  def change
    rename_column :randoku_imgs, :looked_flag, :bookmark_flag
  end
end
