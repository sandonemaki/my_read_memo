class Books::RandokuMemosController < ApplicationController
  def index
    book = Book.find_by(id: params[:book_id])
    new_path = "books/#{book.id}/randoku_memos/index"

    # 学習履歴を保存
    if ['0', '2'].include?(book.reading.to_s)
      RandokuHistory.set(new_path, book.id)
    else
      SeidokuHistory.set(new_path, book.id)
    end

    randoku_img_first_post = book.randoku_imgs.order(:created_at).first
    randoku_img_first_post_filename = randoku_img_first_post ? randoku_img_first_post.name : ""

    # todo: view_modelを作成する
    book_view_model = ViewModel::BooksRandokuMemosIndex.new(
      book: book,
      randoku_img_first_post_filename: randoku_img_first_post_filename
    )
    render("index", locals:{book: book_view_model})
  end

  def new
    book = Book.find_by(id: params[:book_id])
    book_view_model = ViewModel::BooksRandokuMemosNew.new(
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
      redirect_to("/books/#{book.id}/randoku_memos/index")
    else
      book_view_model = ViewModel::BooksRandokuMemosNew.new(
        book: book,
        content_state: params[:value],
        content: params[:content]
      )
      render("new", locals:{book: book_view_model})
    end
  end
end
