Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "book&pages" => "book&pages#new"
  post "book&pages" => "book&pages#create"

  root to: "books#index"
end
