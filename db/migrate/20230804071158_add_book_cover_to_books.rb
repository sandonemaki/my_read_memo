class AddBookCoverToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :book_cover, :string
  end
end
