module Api
  class GameEventsController < ApiController
    before_action :authenticate
    load_and_authorize_resource(class: GameEvent, instance_name: :game_event)
    
    # POST /api/user/game_events
    def create
      @game_event = @current_user.game_events.new(game_event_params)
      
      if @game_event.save
        render json: { game_event: GameEventSerializer.new(@game_event).to_h }, status: :created
      else
        render json: ErrorSerializer.serialize(@game_event.errors), status: :unprocessable_entity
      end
    end
  
    private
  
    def game_event_params
      params.require(:game_event).permit(:type, :occurred_at, :game_id)
    end
  end
end