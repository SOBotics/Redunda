class AddDescriptionToBots < ActiveRecord::Migration[5.1]
  def change
    add_column :bots, :description, :string
  end
end
