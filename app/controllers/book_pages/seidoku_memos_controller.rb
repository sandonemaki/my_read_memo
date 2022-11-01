class BookPages::SeidokuMemosController < ApplicationController
  def index
    book = Book.find_by(id: params[:book_id])
    book_view_model = ViewModel::SeidokuMemos.new(book: book)
    render("index", locals:{book: book_view_model})
  end

  def new
    book = Book.find_by(id: params[:book_id])
    book_view_model = ViewModel::SeidokuMemoNew.new(
      book: book,
    )
    render("new", locals:{book: book_view_model})
  end

  def create
    book = Book.find_by(id: params[:book_id])
    seidoku_memos = book.seidoku_memos.new(
      content_state: params[:value].to_i,
      content: params[:content]
    )
    if seidoku_memos.save
      flash[:notice] = "精読メモを保存しました"
      redirect_to("/book_pages/#{book.id}/seidoku_memos/index")
    else
      book_view_model = ViewModel::SeidokuMemoNew.new(
        book: book,
        content_state: params[:value],
        content: params[:content]
      )
      render("new", locals:{book: book_view_model})
    end
  end
end
