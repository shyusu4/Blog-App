Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  devise_for :users

  devise_scope :user do
    authenticated :user do
      root :to => 'users#show', as: :authenticated_root
    end
    unauthenticated :user do
      root :to => 'devise/registrations#new', as: :unauthenticated_root
    end
  end

  # creating a route for the API
  namespace :api do
    namespace :v1 do
      resources :users do
        resources :posts, format: :json do 
          resources :comments, format: :json 
        end
      end
    end
  end

  # will match a GET request to the given URL and send it to the show action in the UsersController.
  get 'users/:id' => 'users#show', as: "user"

  # will match a GET/POST request to the given URL and send it to the corresponding action in the PostsController.
  get 'users/:author_id/posts/new' => 'posts#new', as: "post_new"
  post 'users/:author_id/posts/new' => 'posts#create', as: "post"
  get 'users/:author_id/posts' => 'posts#index', as: "user_posts"
  get 'users/:author_id/posts/:id' => 'posts#show', as: "user_post"
  delete 'users/:author_id/posts/:id' => 'posts#destroy'

  # will match a GET/POST request to the given URL and send it to the corresponding action in the CommentsController.
  get 'users/:author_id/posts/:id/comments/new' => 'comments#new', as: "comments_new"
  post 'users/:author_id/posts/:id/comments' => 'comments#create', as: "comment"
  delete 'users/:author_id/posts/:id/comments/:comment_id' => 'comments#destroy', as: "comment_destroy"

  # will match a GET request to the given URL and send it to the create action in the LikesController.
  get 'users/:author_id/posts/:id/likes/new' => 'likes#create', as: "likes_create"
end
