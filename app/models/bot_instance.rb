class BotInstance < ApplicationRecord
  belongs_to :bot
  belongs_to :user
end
