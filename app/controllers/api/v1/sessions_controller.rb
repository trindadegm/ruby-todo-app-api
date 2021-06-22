module Api
    module V1
        class SessionsController < ApplicationController
            def create
                user = User
                    .find_by(email: params['email'])
                    .try(:authenticate, params['password'])
                
                if user
                    render json: {
                        logged_in: true,
                        user: user.as_json(only: [:id, :email])
                    }, status: :created
                else
                    render json: {
                        logged_in: false,
                    }, status: :unauthorized
                end
            end
        end
    end
end
