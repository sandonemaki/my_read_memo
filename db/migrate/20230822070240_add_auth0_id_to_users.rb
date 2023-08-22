class AddAuth0IdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :auth0_id, :string
  end
end
