class BookPages::RandokuMemosController < ApplicationController
  def index
    book = Book.find_by(id: params[:book_id])
    new_path = "book_pages/#{book.id}/randoku_memos/index"
    book.reading_state == 0 ?
      RandokuHistory.set(new_path, book.id) : SeidokuHistory.set(new_path, book.id)

    randoku_img_first_post_filename =
      book.randoku_imgs.exists?(id: 1) ? book.randoku_imgs.find_by(id: 1).name : ""
    book_view_model = ViewModel::RandokuMemos.new(
      book: book,
      randoku_img_first_post_filename: randoku_img_first_post_filename
    )
    render("index", locals:{book: book_view_model})
  end

  def new
    book = Book.find_by(id: params[:book_id])
    book_view_model = ViewModel::RandokuMemoNew.new(
      book: book,
    )
    render("new", locals:{book: book_view_model})
  end

  def create
    book = Book.find_by(id: params[:book_id])
    randoku_memos = book.randoku_memos.new(
      content_state: params[:value].to_i,
      content: params[:content]
    )
    if randoku_memos.save
      flash[:notice] = "乱読メモを保存しました"
      redirect_to("/book_pages/#{book.id}/randoku_memos/index")
    else
      book_view_model = ViewModel::RandokuMemoNew.new(
        book: book,
        content_state: params[:value],
        content: params[:content]
      )
      render("new", locals:{book: book_view_model})
    end
  end
end
