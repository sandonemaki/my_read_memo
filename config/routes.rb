Rails
  .application
  .routes
  .draw do
    get 'users/account_setting' => 'users#account_setting'
    put 'users/account_update' => 'users#account_update'

    get 'books/new' => 'books#new' # new_book_page_path
    post 'books/create' => 'books#create' # book_pages_path
    get 'books/:id/' => 'books#show_tabs', :constraints => { id: /\d+/ }
    get 'books/:id/edit' => 'books#edit', :constraints => { id: /\d+/ }
    put 'books/:id/cover_update' => 'books#cover_update', :constraints => { id: /\d+/ }
    put 'books/:id/update' => 'books#update', :constraints => { id: /\d+/ }

    # randoku_inex_ランキング
    #get 'books/randoku_index' => 'books#randoku_index'
    get 'books/randoku_index' => 'books#index_tabs'
    get 'books/randoku_rank_created_books' => 'books#randoku_rank_created_books'
    get 'books/randoku_rank_created_randoku_imgs' => 'books#randoku_rank_created_randoku_imgs'

    # seidoku_inex_ランキング
    get 'books/seidoku_index' => 'books#seidoku_index'
    get 'books/seidoku_rank_created_books' => 'books#seidoku_rank_created_books'
    get 'books/seidoku_rank_most_randoku_imgs' => 'books#seidoku_rank_most_randoku_imgs'

    get 'home/search'

    #get 'books/:id' => 'books#show' # book_page_path
    put 'books/:id/update_total_page' => 'books#update_total_page'

    #randoku_img
    post 'books/:book_id/imgs' => 'books/imgs#create'
    put 'books/:book_id/imgs/:id/toggle_already_read' => 'books/imgs#toggle_already_read'
    put 'books/:book_id/imgs/:id/toggle_bookmark' => 'books/imgs#toggle_bookmark'

    #randoku_memo
    # get 'books/:book_id/randoku_memos/index' => 'books/randoku_memos#index'
    get 'books/:book_id/randoku_memos/new' => 'books/randoku_memos#new'
    post 'books/:book_id/randoku_memos/create' => 'books/randoku_memos#create'

    #seidoku_memo
    # get 'books/:book_id/seidoku_memos/index' => 'books/seidoku_memos#index'
    get 'books/:book_id/seidoku_memos/new' => 'books/seidoku_memos#new'
    post 'books/:book_id/seidoku_memos/create' => 'books/seidoku_memos#create'

    # search
    get 'memo_search' => 'home#memo_search'
    post 'memo_search_result' => 'home#memo_search_result'
    get '/400.html', to: redirect('books#index_tabs')

    # auth0
    get '/auth/auth0/callback' => 'auth0#callback'

    #post '/auth/auth0/callback' => 'auth0#callback'
    get '/auth/failure' => 'auth0#failure'
    get '/auth/logout' => 'auth0#logout'

    root to: 'home#landing'
  end
