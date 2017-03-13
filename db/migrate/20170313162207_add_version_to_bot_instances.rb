class AddVersionToBotInstances < ActiveRecord::Migration[5.1]
  def change
    add_column :bot_instances, :version, :string, default: "unspecified", null: false

    BotInstance.update_all(version: "unspecified")
  end
end
