class UsersController < ApplicationController

    def search
        result = User.fuzzy_search(user_params[:query])

        render json: { data: result }
    end

    private
        def user_params
            params.require(:user).permit(:query)
        end
end