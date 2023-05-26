class AddSeidokuMemoKeyToSeidokuMemos < ActiveRecord::Migration[6.1]
  def change
    add_column :seidoku_memos, :seidoku_memo_key, :boolean, default: true 
  end
end
