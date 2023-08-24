class Books::RandokuMemosController < ApplicationController
  include Secured

  #def index
  #  book = Book.find_by(id: params[:book_id])
  #  new_path = "books/#{book.id}/randoku_memos/index"

  #  # 学習履歴を保存
  #  if %w[0 2].include?(book.reading_state.to_s)
  #    RandokuHistory.set(new_path, book.id)
  #  else
  #    SeidokuHistory.set(new_path, book.id)
  #  end

  #  # todo: view_modelを作成する
  #  book_view_model = ViewModel::BooksRandokuMemosIndex.new(book: book)
  #  render('books/randoku_memos/index', locals: { book: book_view_model })
  #end

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
    book_view_model = ViewModel::BooksRandokuMemosNew.new(book: book)
    render('new', locals: { book: book_view_model, user: user_view_model })
  end

  def create
    book = Book.find_by(id: params[:book_id])
    randoku_memos =
      book.randoku_memos.new(content_state: params[:selectbox_value].first.to_i, content: params[:randoku_memo_content])
    if randoku_memos.save
      flash[:notice] = '乱読メモを保存しました'
      redirect_to "/books/#{book.id}"
    else
      flash.now[:error] = randoku_memos.errors.messages[:content].join(',')
      book_view_model =
        ViewModel::BooksRandokuMemosNew.new(
          book: book,
          selected_content_type: params[:selectbox_value].first,
          randoku_memo_content: params[:randoku_memo_content],
        )
      render('new', locals: { book: book_view_model })
    end
  end
end
