class BooksController < ApplicationController
  require_relative '../modules/state'

  def update_total_page
    book = Book.find_by(id: params[:id])
    book.total_page = img_params[:input_total_page]
    puts "------------------"
    puts book.total_page
    puts img_params[:input_total_page]
    puts "------------------"
    if !book.save
      render json: { status: 500, message: "情報が更新されませんでした。もう一度お試しください" }
      return
    end
    # total_pageの保存が成功した後に実行
    total_page_update_result = book.total_page
    book_reading_state_result = book.try_update_reading_state

    # 本の状態の更新があった場合
    if book_reading_state_result[:updated] == true
      # 本の状態
      book_state_updated_info = State::READING_STATE[book.reading_state]
      json_response = {
        status: :ok,
        book_state_updated_info: book_state_updated_info,
      }
      # 更新された本の状態が"精読"であれば精読メモのタブの鍵を外す
      # 一度falseになると変更されない
      if book_state_updated_info == "精読"
        book.seidoku_memo_key = false
        unless book.save
          render json: { status: 500, message: "本の状態が更新されませんでした。もう一度お試しください" }
          return
        end
        # json_responseに追加
        json_response[:book_seidoku_memo_key] = (book.seidoku_memo_key == false) ? "key_false" : "key_true"
      end
      render json: json_response

    elsif book_reading_state_result[:updated] == false
      render json: {
        status: 502,
        message: "本のステータスの更新ができませんでした。もう一度お試しください"
      }
    else
      render json: {
        status: :ok,
      }
    end
  end

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
    if ['0', '2'].include?(book.reading_state.to_s)
      RandokuHistory.set(new_path, book.id)
    else
      SeidokuHistory.set(new_path, book.id)
    end

    book_view_model = ViewModel::BooksShow.new(book: book)
    render("show", locals: {book: book_view_model})
  end

  def img_params
    params.permit(:input_total_page)
  end
end
