class ChangeAuth0IdInUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_null :users, :auth0_id, false
    add_index :users, :auth0_id, unique: true
  end
end
