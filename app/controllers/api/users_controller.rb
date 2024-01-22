module Api
    class UsersController < ApiController
        before_action :authenticate, except: [:create]
        load_and_authorize_resource(class: User, instance_name: :user, except: [:create])
    
        # POST /api/user
        def create
            @user = User.new(users_params)
            if @user.save
                render json: { user: UserSerializer.new(@user).to_h }, status: :created
            else
                render json: ErrorSerializer.serialize(@user.errors), status: :unprocessable_entity
            end
        end

        # GET /api/user
        def show
            render json: { user: UserSerializer.new(@current_user, {params: { include_stats: true } }).to_h }
        end

        private

        def users_params
            params.require(:user).permit(:email,
                                        :password,
                                        :password_confirmation,
                                        :username,
                                        :full_name
                                        )
        end
    end
end