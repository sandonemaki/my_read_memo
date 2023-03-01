Rails.application.routes.draw do
  get "test/index" => "test#index"

  get 'home/search'
  get "book_pages/new" => "book_pages#new"  # new_book_page_path
  post "book_pages/create" => "book_pages#create"  # book_pages_path
  get "book_pages/create" => "book_pages#new"  # book_pages_path
  get "book_pages/:id" => "book_pages#show" # book_page_path

  #randoku_img
  post "book_pages/:book_id/imgs" => "book_pages/imgs#create" # book_page_imgs_path
  # 乱読画像一覧から乱読画像をクリックしても遷移させないようにするためコメントアウトした
  # get "book_pages/:book_id/imgs/:id" => "book_pages/imgs#show"

  #randoku_memo
  get "book_pages/:book_id/randoku_memos/index" => "book_pages/randoku_memos#index"
  get "book_pages/:book_id/randoku_memos/new" => "book_pages/randoku_memos#new"
  post "book_pages/:book_id/randoku_memos/create" => "book_pages/randoku_memos#create"

  #seidoku_memo
  get "book_pages/:book_id/seidoku_memos/index" => "book_pages/seidoku_memos#index"
  get "book_pages/:book_id/seidoku_memos/new" => "book_pages/seidoku_memos#new"
  post "book_pages/:book_id/seidoku_memos/create" => "book_pages/seidoku_memos#create"

  # search
  get "search" => "home#search"

  get "book_pages/seidoku_index" => "book_pages#seidoku_index"
  root to: "book_pages#randoku_index"
end
