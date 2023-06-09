class CreateSeidokuMemos < ActiveRecord::Migration[6.1]
  def change
    create_table :seidoku_memos do |t|
      t.text :content, default: '', null: false
      t.integer :book_id
      t.integer :content_state, :integer, default: 4, null: false
      t.timestamps
    end
    add_foreign_key :seidoku_memos, :books
  end
end
