class BookPagesController < ApplicationController
  require_relative '../modules/state'

  def index
    books = Book.all.order(created_at: :desc).pluck(
      :id, :title, :author_1, :author_2, :total_page, :reading_state
    )
    index_for_books_view_model = books.map { |book|
      BooksIndex.new(
        id: book[0],
        title: book[1],
        author_1: book[2],
        author_2: book[3],
        total_page: book[4],
        reading_state: book[5])
    }
    # 用途
    # - 乱読画像の未読/読んだカウント
    count = randoku_imgs.reading_state_count(book)
    read_again_count = count[:read_again]
    finish_read_count = count[:finish_read]

    # 用途
    # viesに表示するための乱読画像のカウントインスタンスを作成
    index_for_randoku_img_view_model =
      RandokuImgsIndex.new(
        read_again_count: read_again_count
        finish_read_count: finish_read_count
    )
    render("index", locals:{books: index_for_books_view_model, randoku_imgs: index_for_randoku_img_view_model})
  end

  def new
    book = Book.new
    new_book_view_model =
      book.new_for_book_view_model(book)
    render("new", locals:{book: new_book_view_model})
  end

  def create
    book = Book.new(
      title: params[:title],
      author_1: params[:author_1],
      author_2: params[:author_2],
      publisher: params[:publisher],
      total_page: params[:total_page],
    )
    if book.save
      redirect_to("/book_pages/#{book.id}")
    else
      create_book_view_model =
        book.new_for_book_view_model(book)
      render("new", locals:{book: create_book_view_model})
    end
  end

  # 用途
  # 乱読画像の状態を表示
  # - 状態：また読みたい、読了

  def show
    book = Book.find_by(id: params[:id])
    randoku_imgs = book.randoku_imgs.new
    # randoku_img_paths = Dir.glob("public/#{book.id}/*")
    #   .sort_by { |randoku_img_path| File.birthtime(randoku_img_path) }.reverse
    #puts files = randoku_imgs.files(book)
    #puts count = randoku_imgs.reading_state_count(book)
    show_view_model_for_book_pages(book, randoku_imgs)
  end

  # 用途
  # - インスタンスをviewから参照できるようにする
  def show_view_model_for_book_pages(book, randoku_imgs)
    show_book_view_model =
      book.show_for_book_view_model(book)
    show_randoku_imgs_view_model =
      randoku_imgs.show_for_randoku_img_view_model(randoku_imgs)
    render("show", locals: {book: show_book_view_model, randoku_img: show_randoku_imgs_view_model})
  end
end
