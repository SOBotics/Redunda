class CreateBotData < ActiveRecord::Migration[5.1]
  def change
    create_table :bot_data do |t|
      t.references :bot, foreign_key: true
      t.string :key
      t.mediumblob :data

      t.timestamps
    end
  end
end
