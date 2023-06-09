class CreateSeidokuHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :seidoku_histories do |t|
      t.string :path, default: ''
      t.integer :book_id, default: 0
      t.timestamps
    end
  end
end
