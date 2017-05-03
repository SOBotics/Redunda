class RemoveUsernameFromBotInstances < ActiveRecord::Migration[5.1]
  def change
    BotInstance.all.each do |instance|
      if instance.location.include? "/"
        segments = instance.location.split "/"
        segments.shift
        instance.location = segments.join "/"
        instance.save
      end
    end
  end
end
