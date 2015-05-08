Rails.application.routes.draw do

  root to: 'questions#index'
  
  devise_for :users

  concern :votable do
    member do
      post 'create_vote'
      delete 'delete_vote'
    end
  end

  # resources :questions, concerns: [:votable] do
  #   resources :answers, except: [:index, :show, :edit], shallow: true do
  #     patch :make_best, on: :member
  #   end
  # end

  resources :questions, concerns: [:votable] do
    resources :answers, only: [:create]
  end

  resources :answers, except: [:create], concerns: [:votable] do
    patch 'best_answer', on: :member
  end

  resources :attachments
end
