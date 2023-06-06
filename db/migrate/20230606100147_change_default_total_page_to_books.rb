class ChangeDefaultTotalPageToBooks < ActiveRecord::Migration[6.1]
  def change
    change_column_default :books, :total_page, 20
  end
end
