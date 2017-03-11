class BotInstance < ApplicationRecord
  resourcify

  before_create :generate_key

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


  def generate_key
    self.key = SecureRandom.base64 32
  end
end
