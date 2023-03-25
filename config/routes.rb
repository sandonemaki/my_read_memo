Rails.application.routes.draw do
  get "test/index" => "test#index"

  get 'home/search'
  get "books/new" => "books#new"  # new_book_page_path
  post "books/create" => "books#create"  # book_pages_path
  get "books/create" => "books#new"  # book_pages_path
  get "books/:id" => "books#show" # book_page_path

  #randoku_img
  post "books/:book_id/imgs" => "books/imgs#create" # book_page_imgs_path
  put "books/:book_id/imgs/:id/toggle_already_read" => "books/imgs#toggle_already_read"

  #randoku_memo
  get "books/:book_id/randoku_memos/index" => "books/randoku_memos#index"
  get "books/:book_id/randoku_memos/new" => "books/randoku_memos#new"
  post "books/:book_id/randoku_memos/create" => "books/randoku_memos#create"

  #seidoku_memo
  get "books/:book_id/seidoku_memos/index" => "books/seidoku_memos#index"
  get "books/:book_id/seidoku_memos/new" => "books/seidoku_memos#new"
  post "books/:book_id/seidoku_memos/create" => "books/seidoku_memos#create"

  # search
  get "memo_search" => "home#memo_search"
  post "memo_search_result" => "home#memo_search_result"

  get "books/seidoku_index" => "books#seidoku_index"
  root to: "books#randoku_index"
end
