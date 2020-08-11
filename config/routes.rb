Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end

  get '/search', to: 'search#search'
  get 'answers/edit'
  get 'comments/edit'

  root 'home#top'
  post '/home/guest_sign_in', to: 'home#new_guest'

  get 'home/about'

  resources :posts do
    resource :post_likes, only: [:create, :destroy]
    resources :comments, only: [:create, :edit, :update, :destroy]
  end
  get 'posts/:id/comments/:comment_id' => 'posts#show'
  get 'posts/:id/comments' => 'posts#show'
  post 'comments/:id/comment_likes' => 'comment_likes#create',as: 'post_comments_comment_likes'
  delete 'comments/:id/comment_likes' => 'comment_likes#destroy',as: 'destroy_comment_likes'

  resources :questions do
    resource :empathies, only: [:create, :destroy]
    resources :answers, only: [:create, :edit, :update, :destroy]
  end
  get 'questions/:id/answers/:answer_id' => 'questions#show'
  get 'questions/:id/answers' => 'questions#show'
  post 'answers/:id/answer_likes' => 'answer_likes#create',as: 'question_answers_answer_likes'
  delete 'answers/:id/answer_likes' => 'answer_likes#destroy', as: 'destroy_answer_likes'

  resources :users,only: [:show,:edit,:update,:index] do
    resource :relationships, only: [:create, :destroy]
    get 'follows' => 'relationships#follower', as: 'follows'
    get 'followers' => 'relationships#followed', as: 'followers'
  end

  resources :messages, :only => [:create]
  resources :rooms, :only => [:create, :show, :index]

  resources :notifications, only: :index do
    collection do
      delete '/', to: 'notifications#destroy_all'
    end
  end
end