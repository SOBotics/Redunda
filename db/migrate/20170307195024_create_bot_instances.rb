class CreateBotInstances < ActiveRecord::Migration[5.1]
  def change
    create_table :bot_instances do |t|
      t.references :bot, foreign_key: true
      t.references :user, foreign_key: true
      t.string :location
      t.string :key

      t.timestamps
    end
  end
end
