class BookPages::RandokuMemosController < ApplicationController
  def index
    puts book = Book.find_by(id: params[:book_id])
    randoku_img_first_post_filename =
      if book.randoku_imgs.exists?(id: 1)
        book.randoku_imgs.find_by(id: 1).name
      else
        ""
      end
    randoku_memos_all = book.randoku_memos.all
    book_view_model = ViewModel::RandokuMemos.new(
      book: book,
      randoku_img_first_post_filename: randoku_img_first_post_filename
    )
    render("index", locals:{book: book_view_model})
  end

end
