class Role < ApplicationRecord
  has_and_belongs_to_many :users, :join_table => :users_roles

  belongs_to :resource,
             :polymorphic => true,
             :optional => true

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify

  def self.global_role_names
    [:admin, :developer]
  end

  def self.scoped_roles
    {:owner => Bot, :collaborator => Bot}
  end
end
