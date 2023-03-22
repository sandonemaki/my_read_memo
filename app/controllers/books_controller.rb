class BooksController < ApplicationController
  require_relative '../modules/state'

  def randoku_index
    all_randoku_state_books = Book.where.not(reading_state: "1") # 0 == 乱読, 2 == 通読
    all_seidoku_state_books = Book.where(reading_state: "1") # 1 == 精読
    all_books_count = Book.all.count

    book_view_models = ViewModel::BooksRandokuIndex.new(
      all_randoku_state_books: all_randoku_state_books,
      all_seidoku_state_books: all_seidoku_state_books,
      all_books_count: all_books_count
    )
    render("randoku_index", locals:{books: book_view_models})
  end

  def seidoku_index
    # TODO: 1の部分をString"乱読"にして数字に変換するメソッドを使う
    all_randoku_state_books = Book.where.not(reading_state: "1") # 0 == 乱読, 2 == 通読
    all_seidoku_state_books = Book.where(reading_state: "1") # 1 == 精読
    all_books_count = Book.all.count

    book_view_models = ViewModel::BooksSeidokuIndex.new(
      all_randoku_state_books: all_randoku_state_books,
      all_seidoku_state_books: all_seidoku_state_books,
      all_books_count: all_books_count
    )
    render("seidoku_index", locals:{books: book_view_models})
  end

  def new
    book = Book.new
    book_view_model = ViewModel::BooksNew.new(book: book)
    render("new", locals:{book: book_view_model})
  end

  def create
    book = Book.new(
      title: params[:title],
      author_1: params[:author],
      publisher: params[:publisher],
      total_page: params[:total_page],
    )
    if book.save
      redirect_to("/books/#{book.id}")
    else
      book_view_model =
        ViewModel::BooksNew.new(book: book)
      render("new", locals:{book: book_view_model})
    end
  end

  # 用途
  # 乱読画像の状態を表示
  # - 状態：また読みたい、読了

  def show
    book = Book.find_by(id: params[:id])
    new_path = "books/#{book.id}"

    # 学習履歴を保存
    # TODO: 数字ではなくモデリング名を使用する
    if ['0', '2'].include?(book.reading.to_s)
      RandokuHistory.set(new_path, book.id)
    else
      SeidokuHistory.set(new_path, book.id)
    end

    book_view_model = ViewModel::BooksShow.new(book: book)
    render("show", locals: {book: book_view_model})
  end
end
