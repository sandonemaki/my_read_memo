class Books::SeidokuMemosController < ApplicationController
  def index
    book = Book.find_by(id: params[:book_id])
    new_path = "books/#{book.id}/seidoku_memos/index")
    book.reading_state == 0 || 2 ?
      RandokuHistory.set(new_path, book.id) : SeidokuHistory.set(new_path, book.id)

    book_view_model = ViewModel::BooksSeidokuMemosIndex.new(book: book)
    render("index", locals:{book: book_view_model})
  end

  def new
    book = Book.find_by(id: params[:book_id])
    book_view_model = ViewModel::BooksSeidokuMemosNew.new(
      book: book,
    )
    render("new", locals:{book: book_view_model})
  end

  def create
    book = Book.find_by(id: params[:book_id])
    seidoku_memos = book.seidoku_memos.new(
      content_state: params[:value].first.to_i,
      content: params[:content]
    )
    if seidoku_memos.save
      flash[:notice] = "精読メモを保存しました"
      redirect_to("/books/#{book.id}/seidoku_memos/index")
    else
      book_view_model = ViewModel::BooksSeidokuMemosNew.new(
        book: book,
        seidokumemo_content_type: params[:value].first,
        seidokumemo_content: params[:content]
      )
      render("new", locals:{book: book_view_model})
    end
  end
end
