module Api
    class ApiController < ApplicationController
        

        private

        def api_key_from_header
            bearer_pattern = /^Bearer /
            auth_header = request.env["HTTP_AUTHORIZATION"]

            return unless auth_header

            return auth_header.gsub(bearer_pattern, "") if auth_header.match(bearer_pattern)
        end
        
        def authenticate
            @current_user_token = Session.find_or_initialize_by(token: api_key_from_header)

            if api_key_from_header
                unless @current_user_token.decode_jwt
                    @current_user_token.destroy
                    render json: ErrorSerializer.serialize(@current_user_token.errors), status: :unauthorized
                    return false
                else
                    @current_user_token.update(
                    expiry_at: Time.current + Session::TTL,
                    last_request_at: Time.current,
                    last_request_ip: request.remote_ip,
                    )

                    @current_user = @current_user_token.user
                end
            else
                @current_user_token.errors.add(:token, "Invalid access token")
                render json: ErrorSerializer.serialize(@current_user_token.errors), status: :unauthorized
                return false
            end
        end

        def current_user
            @current_user if defined?(@current_user)
        end
    end
end