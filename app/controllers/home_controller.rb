class HomeController < ApplicationController
  include Secured
  skip_before_action :logged_in_using_omniauth?, only: [:top]
  require_relative '../modules/state'
  def top; end

  def memo_search
    user_info = session[:userinfo]
    return redirect_to root_path, alert: 'ユーザーが存在しないか、セッションが無効です。' unless user_info

    user = User.find_or_initialize_by(auth0_id: user_info['sub'])

    user_view_model = ViewModel::UserName.new(user: user)
    memo_search_menu =
      ViewModel::HomeMemoSearch.new(
        randoku_memo_type: State::RANDOKU_MEMO_Q.merge(State::RANDOKU_MEMO_BKG),
        seidoku_memo_type: State::SEIDOKU_MEMO_TYPE,
      )
    render('memo_search', locals: { search: memo_search_menu, user: user_view_model })
  end

  def memo_search_result
    # "0" が選択された場合の処理
    return redirect_to memo_search_path if params[:selected_search_value].first == '0'

    user_info = session[:userinfo]
    return redirect_to root_path, alert: 'ユーザーが存在しないか、セッションが無効です。' unless user_info

    user = User.find_or_initialize_by(auth0_id: user_info['sub'])

    user_books = user.books

    # TODO: 1の部分に文字列"さらさら読書"を入れる。text -> int に詰め替えるメソッド呼び出しにする
    all_randoku_state_books = user_books.where.not(reading_state: 1) # 0 == さらさら読書：乱読, 2 == さらさら読書：通読
    all_seidoku_state_books = user_books.where(reading_state: 1) # 1 == じっくり読書：精読
    user_view_model = ViewModel::UserName.new(user: user)
    book_view_models =
      ViewModel::HomeMemoSearchResult.new(
        all_books: user_books.all,
        user_books: user_books,
        # key1-4
        randoku_memo_type: State::RANDOKU_MEMO_TYPE,
        # key1-5
        seidoku_memo_type: State::SEIDOKU_MEMO_TYPE,
        # Array<String>
        # "randoku[1-4]" 1-4:randoku_memo_type
        # "seidoku[1-5]" 1-5:seidoku_memo_type
        selected_search_value: params[:selected_search_value].first,
      )
    render('memo_search', locals: { search: book_view_models, user: user_view_model })
  end
end
