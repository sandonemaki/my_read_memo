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
     redirect_to action: :show
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
    book_id = book.id
    book_title = book.title
    book_author_1 = book.author_1
    book_author_2 = book.author_2
    book_publisher = book.publisher
    show_book_view_model =
      BookViewModel::ShowViewModel.new(
        id: book_id,
        title: book_title,
        author_1: book_author_1,
        author_2: book_author_2,
        publisher: book_publisher,
        total_page: book_total_page,
      )
    render("show", locals: {book: show_book_view_model})
  end
end
