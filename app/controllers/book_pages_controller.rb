class BookPagesController < ApplicationController
  require_relative '../module/state'

  def new
    book = Book.new
  end

  def create
    post = Book.new(
      title: params[:title],
      author_1: params[:author_1],
      author_2: params[:author_2],
      publisher: params[:publisher],
      total_page: params[:total_page],
      reading_state: State::READING_STATE[:randoku]
    )
    if book.save
      redirect_to("/book_pages")
    else
      book_title = book.title
      book_author_1 = book.author_1
      book_author_2 = book.author_2
      book_publisher = book.publisher
      book_total_page = book.total_page
      book_reading_state = book.reading_state
      create_book_view_model =
        BookViewModel::NewViewModel.new(
          title: book_title,
          author_1: book_author_1,
          author_2: book_author_2,
          publisher: book_publisher,
          total_page: book_total_page,
          reading_satate: book_reading_state
        )
      render("new", locals:{book: create_book_view_model})
    end
  end

end
