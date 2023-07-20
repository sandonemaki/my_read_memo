class Books::SeidokuMemosController < ApplicationController
  def index
    book = Book.find_by(id: params[:book_id])
    new_path = "books/#{book.id}/seidoku_memos/index"

    # 学習履歴を保存
    if %w[0 2].include?(book.reading_state.to_s)
      RandokuHistory.set(new_path, book.id)
    else
      SeidokuHistory.set(new_path, book.id)
    end

    # todo: view_modelを作成する
    book_view_model = ViewModel::BooksSeidokuMemosIndex.new(book: book)
    render('books/seidoku_memos/index', locals: { book: book_view_model })
  end

  def new
    book = Book.find_by(id: params[:book_id])
    book_view_model = ViewModel::BooksSeidokuMemosNew.new(book: book)
    render('new', locals: { book: book_view_model })
  end

  def create
    book = Book.find_by(id: params[:book_id])
    seidoku_memos =
      book.seidoku_memos.new(content_state: params[:selectbox_value].first.to_i, content: params[:seidoku_memo_content])
    if seidoku_memos.save
      flash[:notice] = '精読メモを保存しました'
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
