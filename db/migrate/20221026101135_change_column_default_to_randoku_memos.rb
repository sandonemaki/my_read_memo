class ChangeColumnDefaultToRandokuMemos < ActiveRecord::Migration[6.1]
  def change
    change_column_default :randoku_memos, :content, from: nil, to: ''
  end
end
