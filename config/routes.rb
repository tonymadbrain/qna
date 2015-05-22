Rails.application.routes.draw do

  root to: 'questions#index'
  
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  concern :votable do
    member do
      post 'create_vote'
      delete 'delete_vote'
    end
  end

  resources :questions, concerns: [:votable] do 
    resources :comments, only: [:create], defaults: { commentable: 'question' }
    resources :answers, concerns: [:votable], except: [:index, :show, :edit], shallow: true do
      resources :comments, only: [:create], defaults: { commentable: 'answer' }
      patch :make_best, on: :member
    end
  end

  resources :comments, :only => [:create]

  resources :attachments, only: [:destroy]  
end
