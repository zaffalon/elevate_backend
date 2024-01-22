class Ability
  include CanCan::Ability

  def initialize(user)
    
    can [:create], Session
    can [:create], User
    
    return if user.blank?

    # Logged user
    can [:index], Game
    can [:show], User, id: user.id
    can [:create], GameEvent, user_id: user.id
  end
end