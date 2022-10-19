class CreateRandokuMemos < ActiveRecord::Migration[6.1]
  def change
    create_table :randoku_memos do |t|
      t.text :content
      t.integer :book_id
      t.timestamps
    end
    add_foreign_key :randoku_memos, :books
  end
end
