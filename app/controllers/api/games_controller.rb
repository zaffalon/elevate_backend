module Api
    class GamesController < ApiController
        before_action :authenticate
        load_and_authorize_resource(class: Game)
    
        # GET /api/games
        def index
            @games = Game.all
            render json: { games: GameSerializer.new(@games).to_h }
        end
    end
end
