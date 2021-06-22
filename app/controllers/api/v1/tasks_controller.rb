module Api
    module V1
        class TasksController < ApplicationController
            def index
                tasks = Task.order('created_at');
                render json: {
                    status: 'SUCCESS',
                    message: 'Tasks loaded',
                    data: tasks
                }, status: :ok
            end

            def show
                task = Task.find params[:id]
                render json: {
                    status: 'SUCCESS',
                    message: 'Task loaded',
                    data: task
                }, status: :ok
            end

            def create
                token = params[:jwt]
                if token
                    user_id = get_user_id_from_token(token)
                    if user_id
                        task = Task.new(
                            title: params[:title],
                            description: params[:description],
                            visibility: params[:visibility],
                            status: params[:status],
                            owner: user_id
                        )

                        if task.save
                            return render json: {
                                status: 'SUCCESS',
                                message: 'Task saved',
                            }, status: :ok
                        else
                            return render json: {
                                status: 'Error',
                                message: 'Task not saved',
                            }, status: :unprocessable_entity
                        end
                    end
                end
                render json: {
                    status: 'Error',
                    message: 'Invalid token',
                }, status: :unauthorized
            end

            def update
                task = Task.find params[:id]
                if task.update task_params
                    render json: {
                        status: 'SUCCESS',
                        message: 'Task updated',
                    }, status: :ok
                else
                    render json: {
                        status: 'Error',
                        message: 'Task not updated',
                    }, status: :unprocessable_entity
                end
            end

            def destroy
                task = Task.find params[:id]
                task.destroy 
                render json: {
                    status: 'SUCCESS',
                    message: 'Task deleted',
                }, status: :ok
            end
            
            private

            def task_params
                params.permit :jwt, :title, :description, :status, :visibility
            end
        end
    end
end