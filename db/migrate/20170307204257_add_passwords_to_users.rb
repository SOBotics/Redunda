class AddPasswordsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :encrypted_password, :string, null: false, default: ""
  end
end
