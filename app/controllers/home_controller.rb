class HomeController < ApplicationController
  require_relative '../modules/state'

  def memo_search
    memo_search_menu = ViewModel::HomeMemoSearch.new(
      randoku_memo_type: State::RANDOKU_MEMO_Q.merge(State::RANDOKU_MEMO_BKG),
      seidoku_memo_type: State::SEIDOKU_MEMO_TYPE,
    )
    render("memo_search", locals:{search: memo_search_menu})
  end

  def memo_search_result
    # TODO: 1の部分に文字列"乱読"を入れる。text -> int に詰め替えるメソッド呼び出しにする
    all_randoku_state_books = Book.where.not(reading_state: "1") # 0 == 乱読, 2 == 通読
    all_seidoku_state_books = Book.where(reading_state: "1") # 1 == 精読
    book_view_models = ViewModel::HomeMemoSearchResult.new(
      all_randoku_state_books: all_randoku_state_books,
      all_seidoku_state_books: all_seidoku_state_books,

      randoku_memo_type: State::RANDOKU_MEMO_Q.merge(State::RANDOKU_MEMO_BKG),
      seidoku_memo_type: State::SEIDOKU_MEMO_TYPE,
      # Array<String>
      # "randoku[0-4]" 0-4:randoku_memo_type
      # "seidoku[0-4]" 0-4:seidoku_memo_type
      content_type: params[:value]
   )
    render("search", locals:{books: book_view_models})
  end
end
