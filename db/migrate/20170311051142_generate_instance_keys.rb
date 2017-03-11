class GenerateInstanceKeys < ActiveRecord::Migration[5.1]
  def change
    BotInstance.where(key: "")
    .or(BotInstance.where(key: nil))
    .each do |instance|
      instance.update(key: SecureRandom.base64(32))
    end

    reversible do |dir|
      change_table :bot_instances do |t|
        dir.up   { t.change :key, :string, :null => false }
        dir.down { t.change :key, :string, :null => true }
      end
    end

    add_index :bot_instances, :key, :unique => true
  end
end
