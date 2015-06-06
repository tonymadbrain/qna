Rails.application.routes.draw do

  use_doorkeeper
  root to: 'questions#index'
  
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations' }

  concern :votable do
    member do
      post 'create_vote'
      delete 'delete_vote'
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions do
        resources :answers, shallow: true
      end
    end
  end

  resources :questions, concerns: [:votable] do 
    post :subscribe, on: :member
    post :unsubscribe, on: :member
    resources :comments, only: [:create], defaults: { commentable: 'question' }
    resources :answers, concerns: [:votable], except: [:index, :show, :edit], shallow: true do
      resources :comments, only: [:create], defaults: { commentable: 'answer' }
      patch :make_best, on: :member
    end
  end

  resources :comments, :only => [:create]

  resources :attachments, only: [:destroy]  
  
  resources :identities, only: :show do
    get :confirm, on: :member
  end
end
