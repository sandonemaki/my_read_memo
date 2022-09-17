class CreateRandokuImgs < ActiveRecord::Migration[6.1]
  def change
    create_table :randoku_imgs do |t|
      t.integer :first_post_flag, default: 0, null: false
      t.integer :looked_flag, default: 0, null: false
      t.string :path, null: false
      t.string :name, null: false
      t.integer :reading_state, default: 0, null: false
      t.references :book, foreign_key: true
      t.timestamps
    end
  end
end
