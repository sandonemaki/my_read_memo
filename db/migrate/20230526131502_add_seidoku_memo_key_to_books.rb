class AddSeidokuMemoKeyToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :seidoku_memo_key, :boolean, default: true
  end
end
