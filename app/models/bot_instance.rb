class BotInstance < ApplicationRecord
  resourcify

  belongs_to :bot
  belongs_to :user

  def status_class
    if last_ping.nil?
      return "bot-status-nil"
    end
    if last_ping > 1.minute.ago
      "bot-status-okay"
    elsif last_ping < 1.minute.ago && last_ping > 3.minutes.ago
      "bot-status-warn"
    else
      "bot-status-dead"
    end
  end
end
