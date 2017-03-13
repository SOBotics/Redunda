class AddPriorityToInstances < ActiveRecord::Migration[5.1]
  def change
    add_column :bot_instances, :priority, :int, index: true

    BotInstance.all.each do |instance|
      instance.update(priority: instance.id)
    end
  end
end
