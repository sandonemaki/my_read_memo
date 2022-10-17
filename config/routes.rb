Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "book_pages/new" => "book_pages#new"  # new_book_page_path
  post "book_pages/create" => "book_pages#create"  # book_pages_path
  get "book_pages/create" => "book_pages#new"  # book_pages_path
  get "book_pages/:id" => "book_pages#show" # book_page_path
  post "book_pages/:book_id/imgs" => "book_pages/imgs#create" # book_page_imgs_path
  root to: "book_pages#index"
end
