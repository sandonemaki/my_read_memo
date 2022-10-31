class BookPages::RandokuMemosController < ApplicationController
  def index
    book = Book.find_by(id: params[:book_id])
    randoku_img_first_post_filename =
      if book.randoku_imgs.exists?(id: 1)
        puts book.randoku_imgs.find_by(id: 1).name
      else
        ""
      end
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
      time_now: I18n.l(Time.now, format: :short)
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
        content_state: params[:content_state]
      )
      render("new", locals:{book: book_view_model})
    end
  end
end
