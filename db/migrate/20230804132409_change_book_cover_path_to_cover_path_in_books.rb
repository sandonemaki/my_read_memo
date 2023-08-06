class ChangeBookCoverPathToCoverPathInBooks < ActiveRecord::Migration[6.1]
  def change
    rename_column :books, :book_cover_path, :cover_path
  end
end
