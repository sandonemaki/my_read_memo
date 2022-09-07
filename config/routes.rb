Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "book_pages" => "book_pages#new"
  post "book_pages" => "book_pages#create"

  root to: "books#index"
end
