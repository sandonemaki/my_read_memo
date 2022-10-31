class BookPagesController < ApplicationController
  require_relative '../modules/state'

  def index
    book_view_models = Book.all.order(created_at: :desc).to_a.map { |book|
      ViewModel::BookViewModel.new(book: book)
    }
    render("index", locals:{books: book_view_models})
  end

  def new
    book = Book.new
    book_view_model = ViewModel::BookViewModel.new(book: book)
    render("new", locals:{book: book_view_model})
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
      book_view_model =
        ViewModel::BookViewModel.new(book: book)
      render("new", locals:{book: book_view_model})
    end
  end

  # 用途
  # 乱読画像の状態を表示
  # - 状態：また読みたい、読了

  def show
    book = Book.find_by(id: params[:id])
    book_view_model = ViewModel::BookViewModel.new(book: book)
    render("show", locals: {book: book_view_model})
  end
end
