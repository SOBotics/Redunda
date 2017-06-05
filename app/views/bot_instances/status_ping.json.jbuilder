json.should_standby !(@bot.preferred_instance == @bot_instance)
json.location @bot_instance.human_location
json.event_count Event.where(bot: @bot).count + Event.where(bot_instance: @bot_instance).count
