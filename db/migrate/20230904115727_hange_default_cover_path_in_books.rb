class HangeDefaultCoverPathInBooks < ActiveRecord::Migration[6.1]
  def up
    change_column :books, :cover_path, :string, default: '/illust/book_default_2d.png'
  end

  def down
    change_column :books, :cover_path, :string, default: '/default_book.png'
  end
end
