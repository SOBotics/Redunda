class Bot < ApplicationRecord
  resourcify

  has_many :bot_instances, :dependent => :destroy

  validates :name, length: { minimum: 3 }

  def owner
    User.with_role(:owner, self).first!
  end

  def collaborators
    User.with_role(:collaborator, self)
  end

  def eligible_collaborators
    User.where.not(:id => User.with_role(:owner, self).pluck(:id))
        .where.not(:id => User.with_role(:collaborator, self).pluck(:id))
        .order(:username)
        .map{ |u| [u.username, u.id] }
  end

  def preferred_instance
    result = bot_instances
              .where('last_ping > ?', 3.minutes.ago)
              .order(:priority)
              .first

    if result == nil
      return bot_instances.order(:priority).first
    end
    return result
  end
end
