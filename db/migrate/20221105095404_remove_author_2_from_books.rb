class RemoveAuthor2FromBooks < ActiveRecord::Migration[6.1]
  def change
    remove_column :books, :author_2, :string
  end
end
