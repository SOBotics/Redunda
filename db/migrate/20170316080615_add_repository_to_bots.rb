class AddRepositoryToBots < ActiveRecord::Migration[5.1]
  def change
    add_column :bots, :repository, :string
  end
end
