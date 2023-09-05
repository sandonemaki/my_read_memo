class Books::SeidokuMemosController < ApplicationController
  include Secured

  def new
    user_info = session[:userinfo]
    return redirect_to root_path, alert: 'ユーザーが存在しないか、セッションが無効です。' unless user_info

    user = User.find_or_initialize_by(auth0_id: user_info['sub'])
    user_books = user.books
    book = user_books.find_by(id: params[:book_id])
    unless book
      flash[:error] = 'ページが見つかりませんでした'
      redirect_to '/books/randoku_index'
      return
    end
    user_view_model = ViewModel::UserName.new(user: user)
    book_view_model = ViewModel::BooksSeidokuMemosNew.new(book: book)
    render('new', locals: { book: book_view_model, user: user_view_model })
  end

  def create
    user_info = session[:userinfo]
    return redirect_to root_path, alert: 'ユーザーが存在しないか、セッションが無効です。' unless user_info

    user = User.find_or_initialize_by(auth0_id: user_info['sub'])
    user_books = user.books
    book = user_books.find_by(id: params[:book_id])
    seidoku_memos =
      book.seidoku_memos.new(content_state: params[:selectbox_value].first.to_i, content: params[:seidoku_memo_content])
    if seidoku_memos.save
      flash[:notice] = 'じっくり読書メモを保存しました'
      redirect_to "/books/#{book.id}"
    else
      flash.now[:error] = randoku_memos.errors.messages[:content].join(',')
      book_view_model =
        ViewModel::BooksSeidokuMemosNew.new(
          book: book,
          selected_content_type: params[:selectbox_value].first, # viewに表示するためString
          seidoku_memo_content: params[:seidoku_memo_content],
        )
      render('new', locals: { book: book_view_model })
    end
  end
end
