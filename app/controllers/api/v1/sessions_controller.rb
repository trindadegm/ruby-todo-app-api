module Api
    module V1
        class SessionsController < ApplicationController
            def create
                user = User
                    .find_by(email: params['email'])
                    .try(:authenticate, params['password'])
                
                if user
                    token = generate_token(user)
                    render json: {
                        logged_in: true,
                        user: user.as_json(only: [:id, :email]),
                        jwt: token
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
