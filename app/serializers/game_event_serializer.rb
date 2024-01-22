class GameEventSerializer < ApplicationSerializer
  attributes :id, :occurred_at, :game_id, :user_id, :type
  
  # belongs_to :game
  # belongs_to :user
end
