class GameEvent < ApplicationRecord
  self.inheritance_column = nil

  belongs_to :game
  belongs_to :user

  enum :type, { COMPLETED: 0 }, validate: true

  validates :occurred_at, presence: true
  validates :type, presence: true
  
  after_commit :remove_user_caches

  def remove_user_caches
    Rails.cache.delete([user, 'stats'])
  end
end
