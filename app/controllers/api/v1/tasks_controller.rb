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
                task = Task.new task_params

                if task.save
                    render json: {
                        status: 'SUCCESS',
                        message: 'Task saved',
                    }, status: :ok
                else
                    render json: {
                        status: 'Error',
                        message: 'Task not saved',
                    }, status: :unprocessable_entity
                end
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
                params.permit :title, :description, :owner, :status, :visibility
            end
        end
    end
end