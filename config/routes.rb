Rails.application.routes.draw do
  get 'seidoku_memos/index'
  get 'seidoku_memos/create'
  get 'seidoku_memos/new'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "book_pages/new" => "book_pages#new"  # new_book_page_path
  post "book_pages/create" => "book_pages#create"  # book_pages_path
  get "book_pages/create" => "book_pages#new"  # book_pages_path
  get "book_pages/:id" => "book_pages#show" # book_page_path
  post "book_pages/:book_id/imgs" => "book_pages/imgs#create" # book_page_imgs_path

  #randoku_memo
  get "book_pages/:book_id/randoku_memos/index" => "book_pages/randoku_memos#index"
  get "book_pages/:book_id/randoku_memos/new" => "book_pages/randoku_memos#new"
  post "book_pages/:book_id/randoku_memos/create" => "book_pages/randoku_memos#create"

  #seidoku_memo
  get "book_pages/:book_id/seidoku_memos/index" => "book_pages/seidoku_memos#index"
  get "book_pages/:book_id/seidoku_memos/new" => "book_pages/seidoku_memos#new"
  post "book_pages/:book_id/seidoku_memos/create" => "book_pages/seidoku_memos#create"


  root to: "book_pages#index"
end
