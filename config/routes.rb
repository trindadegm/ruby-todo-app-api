Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :tasks
      resources :users, only: [:create]
      resources :sessions, only: [:create]
    end
  end
end
