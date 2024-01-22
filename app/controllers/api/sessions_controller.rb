module Api
  class SessionsController < ApiController
    load_and_authorize_resource(class: Session, instance_name: :session)

    # POST /api/sessions
    def create
      if params[:email]
        user = User.find_by(email: params[:email])
        unless user.present?
          return render json: { message: "invalid_login", code: "invalid_login" }, status: :unprocessable_entity
        end

        if user&.valid_password?(params[:password])
          session = Session.create!(
            user_id: user.id,
            expiry_at: Time.current + Session::TTL,
            user_agent: request.user_agent,
            create_ip: request.remote_ip,
          )
      

          render json: { token: session.token, token_type: "Bearer", expires_in: Session::TTL }, status: :created
        else
          render json: { message: "invalid_login", code: "invalid_login" }, status: :unprocessable_entity
        end
      else
        render json: { message: "invalid_login", code: "invalid_login" }, status: :unprocessable_entity
      end
    end
  end
end