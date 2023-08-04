class ChangeBookCoverToBookCoverPathInBooks < ActiveRecord::Migration[6.1]
  def change
    rename_column :books, :book_cover, :book_cover_path
    change_column :books, :book_cover_path, :string, default: '/default_book.png'
  end
end
