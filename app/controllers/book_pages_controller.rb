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

  def show
    book = Book.find_by(id: params[:id])
    # 用途
    # viewで乱読画像を表示する
    # - 更新順
    # - 生成順_現在は使用しない
    #
    randoku_img_paths = Dir.glob("public/#{book.id}/*")
      .sort_by { |randoku_img_path| File.mtime(randoku_img_path) }.reverse

    # randoku_img_paths = Dir.glob("public/#{book.id}/*")
    #   .sort_by { |randoku_img_path| File.birthtime(randoku_img_path) }.reverse

    # ファイル名を取得
    randoku_img_files = randoku_img_paths.map { |f| f.gsub(/public\/#{book.id}\//, '') }
    show_view_model_for_book(book, randoku_img_files)
  end

  # 用途
  # - インスタンスをviewから参照できるようにする
  def show_view_model_for_book(book, randoku_img_files)
    book_id = book.id
    book_title = book.title
    book_author_1 = book.author_1
    book_author_2 = book.author_2
    book_publisher = book.publisher
    book_total_page = book.total_page
    book_errors = book.errors
    show_book_view_model =
      BookViewModel::ShowViewModel.new(
        id: book_id,
        title: book_title,
        author_1: book_author_1,
        author_2: book_author_2,
        publisher: book_publisher,
        total_page: book_total_page,
        errors: book_errors,
      )
    show_randoku_imgs_view_model =
      RandokuImgViewModel::ShowViewModel.new(
        files: randoku_img_files,
      )
    render("show", locals: {book: show_book_view_model, randoku_img: show_randoku_imgs_view_model})
  end
end
