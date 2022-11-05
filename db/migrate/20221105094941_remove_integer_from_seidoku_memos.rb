class RemoveIntegerFromSeidokuMemos < ActiveRecord::Migration[6.1]
  def change
    remove_column :seidoku_memos, :integer, :integer
  end
end
