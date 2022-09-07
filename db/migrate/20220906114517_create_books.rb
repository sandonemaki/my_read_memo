class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :title, :limit => 60, default: "", null: false
      t.string :author_1, :limit => 60, default: "", null: false
      t.string :author_2, :limit => 60, default: ""
      t.string :publisher, :limit => 60, default: ""
      t.integer :total_page, null: false
      t.integer :reading_state, null: false, default: 0
      t.timestamps
    end
  end
end
