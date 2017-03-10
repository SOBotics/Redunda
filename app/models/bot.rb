class Bot < ApplicationRecord
  resourcify

  has_many :bot_instances

  def eligible_collaborators
    User.where.not(:id => User.with_role(:owner, self).pluck(:id))
        .where.not(:id => User.with_role(:collaborator, self).pluck(:id))
        .order(:username)
        .map{ |u| [u.username, u.id] }
  end
end
