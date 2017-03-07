class AddLastPingToBotInstances < ActiveRecord::Migration[5.1]
  def change
    add_column :bot_instances, :last_ping, :datetime
  end
end
