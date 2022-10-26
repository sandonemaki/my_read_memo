class ChangeColumnDefaultToBooks < ActiveRecord::Migration[6.1]
  def change
    change_column_default :books, :total_page, from: nil, to: 0
  end
end
