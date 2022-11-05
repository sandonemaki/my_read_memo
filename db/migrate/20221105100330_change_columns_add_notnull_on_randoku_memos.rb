class ChangeColumnsAddNotnullOnRandokuMemos < ActiveRecord::Migration[6.1]
  def change
    change_column_null :randoku_memos, :content, false
  end
end
