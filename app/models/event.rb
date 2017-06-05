class EventValidator < ActiveModel::Validator
  def validate(event)
    if event.bot == nil && event.bot_instance == nil
      event.errors[:base] << "An Event must have either a bot or an instance"
    elsif event.bot != nil && event.bot_instance != nil
      event.errors[:base] << "An Event may not have both a bot and an instance"
    end
  end
end

class Event < ApplicationRecord
  belongs_to :bot, optional: true
  belongs_to :bot_instance, optional: true
end
