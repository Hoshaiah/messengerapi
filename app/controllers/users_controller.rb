class UsersController < ApplicationController
    before_action :authenticate_user, only: %i[ search ] 

    def search
        result = User.fuzzy_search(user_params[:query], current_user.id)

        render json: { data: result }
    end

    private
        def user_params
            params.require(:user).permit(:query)
        end

        def authenticate_user
            if request.headers['Authorization'].present?
              jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.devise_jwt_secret_key!).first
              current_user = User.find(jwt_payload['sub'])
            end
            
            if !current_user || jwt_payload['jti'] != current_user.jti
              render json: {
                status: 404,
                message: "You do not have permission to do this action."
              }
              return
            end
        end
end