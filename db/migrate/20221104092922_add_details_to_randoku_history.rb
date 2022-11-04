class AddDetailsToRandokuHistory < ActiveRecord::Migration[6.1]
  def change
    add_column :randoku_histories, :book_id, :integer, default: 0
  end
end
