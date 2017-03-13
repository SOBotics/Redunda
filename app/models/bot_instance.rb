class BotInstance < ApplicationRecord
  resourcify

  before_create :generate_key
  before_create :populate_priority

  belongs_to :bot
  belongs_to :user

  def status
    if last_ping.nil?
      return nil
    end
    if last_ping > 1.minute.ago
      return :okay
    elsif last_ping < 1.minute.ago && last_ping > 3.minutes.ago
      return :warn
    else
      return :dead
    end
  end

  def status_class
    if self.status == :okay
      return "bot-status-okay"
    elsif self.status == :warn
      return "bot-status-warn"
    elsif self.status == :dead
      return "bot-status-dead"
    end
    return "bot-status-nil"
  end

  def panel_class
    if self.status == :okay
      return "panel-success"
    elsif self.status == :warn
      return "panel-warning"
    elsif self.status == :dead
      return "panel-danger"
    end
    return "panel-default"
  end


  def generate_key
    self.key = SecureRandom.base64 32
  end

  def populate_priority
    self.priority = self.id
  end
end
