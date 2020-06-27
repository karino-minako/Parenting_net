Rails.application.routes.draw do
  get 'searchs/search'
  get 'answers/edit'
  get 'comments/edit'
  devise_for :users

  root 'home#top'

  get 'home/about'

  resources :posts do
    resource :post_likes, only: [:create, :destroy]
  	resource :comments, only: [:create, :edit, :update, :destroy]
  end
  post 'comments/:id/comment_likes' => 'comment_likes#create',as: 'post_comments_comment_likes'
  delete 'comments/:id/comment_likes' => 'comment_likes#destroy',as: 'destroy_comment_likes'
  get 'posts/likes/rank' => 'posts#post_like_ranks'
  get 'comments/likes/rank/:post_id' => 'comments#comment_like_ranks', as: 'comment_like_ranks'

  resources :questions do
    resource :empathies, only: [:create, :destroy]
  	resource :answers, only: [:create, :edit, :update, :destroy]
  end
  post 'answers/:id/answer_likes' => 'answer_likes#create',as: 'question_answers_answer_likes'
  delete 'answers/:id/answer_likes' => 'answer_likes#destroy', as: 'destroy_answer_likes'
  get 'questions/empathies/rank' => 'questions#empathy_ranks'
  get 'answers/likes/rank/:question_id' => 'answers#answer_like_ranks', as: 'answer_like_ranks'

  resources :users,only: [:show,:edit,:update,:index] do
    resource :relationships, only: [:create, :destroy]
    get 'follows' => 'relationships#follower', as: 'follows'
    get 'followers' => 'relationships#followed', as: 'followers'
  end

  get '/search', to: 'search#search'
end
