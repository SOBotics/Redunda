class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.references :bot, foreign_key: true
      t.references :bot_instance, foreign_key: true
      t.string :headers
      t.string :content
      t.string :name

      t.timestamps
    end
  end
end
