class HomeController < ApplicationController
  def search
    all_randoku_state_books = Book.where(reading_state: "0").where(reading_state: "2") # 0 == 乱読, 2 == 通読
    all_seidoku_state_books = Book.where(reading_state: "1") # 1 == 精読
    book_view_models = ViewModel::HomeSearch.new(
      all_randoku_state_books: all_randoku_state_books,
      all_seidoku_state_books: all_seidoku_state_books,
      content_type: params[:value],
      randoku_memo_type: State::RANDOKU_MEMO_Q.merge(State::RANDOKU_MEMO_BKG),
      seidoku_memo_type: State::SEIDOKU_MEMO_TYPE
    )
    render("search", locals:{books: book_view_models})
  end
end
