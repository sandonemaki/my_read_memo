class BookPagesController < ApplicationController
  require_relative '../modules/state'

  def new
    book = Book.new
    book_title = book.title
    book_author_1 = book.author_1
    book_author_2 = book.author_2
    book_publisher = book.publisher
    book_total_page = book.total_page
    book_errors = book.errors
    create_book_view_model =
      BookViewModel::NewViewModel.new(
        title: book_title,
        author_1: book_author_1,
        author_2: book_author_2,
        publisher: book_publisher,
        total_page: book_total_page,
        errors: book_errors
      )
    render("new", locals:{book: create_book_view_model})
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
      book_title = book.title
      book_author_1 = book.author_1
      book_author_2 = book.author_2
      book_publisher = book.publisher
      book_total_page = book.total_page
      book_errors = book.errors
      create_book_view_model =
        BookViewModel::NewViewModel.new(
          title: book_title,
          author_1: book_author_1,
          author_2: book_author_2,
          publisher: book_publisher,
          total_page: book_total_page,
          errors: book_errors
        )
      render("new", locals:{book: create_book_view_model})
    end
  end

  # 用途
  # 乱読画像の状態を表示
  # - 状態：また読みたい、読了

#  ToDo:消す
#  def randoku_img_reading_state_count(book)
#    if book.randoku_imgs.loaded?
#      reading_state = book.randoku_imgs.group('reading_state').size
#    else
#      reading_state = book.randoku_imgs.group('reading_state').count
#    end
#    @read_again = (reading_state[0] ||= 0)
#    @finish_read = (reading_state[1] ||= 0)
#  end

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
