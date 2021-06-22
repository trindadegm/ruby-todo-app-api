module Api
    module V1
        class UsersController < ApplicationController
            def create
                user = User.new user_params
                if user.save
                    render json: {
                        status: 'SUCCESS',
                        message: 'User created',
                    }, status: :ok
                else
                    render json: {
                        status: 'Error',
                        message: 'Could not create user',
                    }, status: :unprocessable_entity
                end
            end

            private

            def user_params
                params.permit :name, :email, :password
            end
        end
    end
end
