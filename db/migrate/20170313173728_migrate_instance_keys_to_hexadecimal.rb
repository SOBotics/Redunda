class MigrateInstanceKeysToHexadecimal < ActiveRecord::Migration[5.1]
  def change
    BotInstance.all.each do |instance|
      instance.update!(:key => SecureRandom.hex(32))
    end
  end
end
