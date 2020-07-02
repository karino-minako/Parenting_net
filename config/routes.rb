Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  get 'searchs/search'
  get 'answers/edit'
  get 'comments/edit'

  root 'home#top'

  get 'home/about'

  resources :posts do
    resource :post_likes, only: [:create, :destroy]
  	resource :comments, only: [:create, :edit, :update, :destroy]
  end
  post 'comments/:id/comment_likes' => 'comment_likes#create',as: 'post_comments_comment_likes'
  delete 'comments/:id/comment_likes' => 'comment_likes#destroy',as: 'destroy_comment_likes'

  resources :questions do
    resource :empathies, only: [:create, :destroy]
  	resource :answers, only: [:create, :edit, :update, :destroy]
  end
  post 'answers/:id/answer_likes' => 'answer_likes#create',as: 'question_answers_answer_likes'
  delete 'answers/:id/answer_likes' => 'answer_likes#destroy', as: 'destroy_answer_likes'

  resources :users,only: [:show,:edit,:update,:index] do
    resource :relationships, only: [:create, :destroy]
    get 'follows' => 'relationships#follower', as: 'follows'
    get 'followers' => 'relationships#followed', as: 'followers'
  end

  get '/search', to: 'search#search'
end
