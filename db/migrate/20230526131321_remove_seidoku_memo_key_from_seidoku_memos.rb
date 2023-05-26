class RemoveSeidokuMemoKeyFromSeidokuMemos < ActiveRecord::Migration[6.1]
  def change
    remove_column :seidoku_memos, :seidoku_memo_key, :boolean
  end
end
