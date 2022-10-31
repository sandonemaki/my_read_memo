class AddContentStateToRandokuMemos < ActiveRecord::Migration[6.1]
  def change
    add_column :randoku_memos, :content_state, :integer, default: 3, null: false
  end
end
