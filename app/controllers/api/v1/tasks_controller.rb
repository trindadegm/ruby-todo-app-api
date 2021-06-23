module Api
    module V1
        class TasksController < ApplicationController
            def status_filter
                if params[:with_status] == 'pending' || params[:with_status] == 'done'
                    params[:with_status]
                else
                    nil
                end
            end

            def visibility_filter
                if params[:with_visibility] == 'public' || params[:with_visibility] == 'private'
                    params[:with_visibility]
                else
                    nil
                end
            end

            def index
                # Get some parameters (may be nil)
                user_id = auth_user_from_header_token

                if user_id
                    # User is authenticated
                    query = '(owner = :user_id';
                    if visibility_filter
                        query += ' and visibility = :visibility)'
                    else
                        query += " or visibility = 'public')"
                    end
                    if status_filter
                        query += ' and status = :status'
                    end
                    tasks = Task
                        .where(query, {user_id: user_id, visibility: visibility_filter, status: status_filter})
                        .order('created_at');
                    render json: {
                        status: 'SUCCESS',
                        message: 'Tasks loaded',
                        data: tasks
                    }, status: :ok
                else
                    # Not authorized to show any task
                    render json: {
                        status: 'Error',
                        message: 'Token is missing, is invalid or has expired',
                    }, status: :unauthorized
                end
            end

            def show
                user_id = auth_user_from_header_token
                if user_id
                    task = Task.find params[:id]
                    if task.visibility != "private" || task.owner == user_id
                        render json: {
                            status: 'SUCCESS',
                            message: 'Task loaded',
                            data: task
                        }, status: :ok
                    else
                        # Not authorized to show this task
                        render json: {
                            status: 'Error',
                            message: 'This task is private and it is not yours',
                        }, status: :unauthorized
                    end
                else
                    # Not authorized to show any task
                    render json: {
                        status: 'Error',
                        message: 'Token is missing, is invalid or has expired',
                    }, status: :unauthorized
                end
            end

            def create
                user_id = auth_user_from_header_token
                if user_id
                    # Authorized to create tasks
                    args = task_params
                    args[:owner] = user_id
                    task = Task.new args

                    if task.save
                        return render json: {
                            status: 'SUCCESS',
                            message: 'Task saved',
                        }, status: :created
                    else
                        return render json: {
                            status: 'Error',
                            message: 'Task not saved',
                        }, status: :unprocessable_entity
                    end
                else
                    # Not authorized to create tasks
                    render json: {
                        status: 'Error',
                        message: 'Token is missing, is invalid or has expired',
                    }, status: :unauthorized
                end
            end

            def update
                user_id = auth_user_from_header_token
                if user_id
                    # Authorized to update tasks
                    args = task_params
                    args[:owner] = user_id
                    
                    task = Task.find params[:id]
                    if task.owner == user_id && task.status == "pending"
                        if task.update args
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
                    else
                        render json: {
                            status: 'Error',
                            message: task.owner != user_id ? 'This task is not yours' : 'This task is done and cannot be changed',
                        }, status: :unauthorized
                    end
                else
                    # Not authorized to update tasks
                    render json: {
                        status: 'Error',
                        message: 'Token is missing, is invalid or has expired',
                    }, status: :unauthorized
                end
            end

            def destroy
                user_id = auth_user_from_header_token
                if user_id
                    # Authorized to destroy tasks
                    task = Task.find params[:id]
                    if task.owner == user_id
                        if task.destroy
                            render json: {
                                status: 'SUCCESS',
                                message: 'Task deleted',
                            }, status: :ok
                        else
                            render json: {
                                status: 'Error',
                                message: 'Task not deleted',
                            }, status: :unprocessable_entity
                        end
                    else
                        render json: {
                            status: 'Error',
                            message: 'This task is not yours',
                        }, status: :unauthorized
                    end
                else
                    # Not authorized to update tasks
                    render json: {
                        status: 'Error',
                        message: 'Token is missing, is invalid or has expired',
                    }, status: :unauthorized
                end
            end
            
            private

            def task_params
                params.permit :title, :description, :status, :visibility
            end
        end
    end
end