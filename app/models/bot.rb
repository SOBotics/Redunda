class Bot < ApplicationRecord
  resourcify

  has_many :bot_instances
end
