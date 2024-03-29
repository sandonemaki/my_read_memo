module ViewModel
  class HomeMemoSearch
    attr_reader :randoku_memo_type, :seidoku_memo_type, :selected_search_value,
      :selected_memos, :randoku_memo_selected_menu, :seidoku_memo_selected_menu

    def initialize(randoku_memo_type:, seidoku_memo_type:)
      @randoku_memo_type = randoku_memo_type
      @seidoku_memo_type = seidoku_memo_type
      @selected_search_value = ""
      @selected_memos = nil
      @randoku_memo_selected_menu = ""
      @seidoku_memo_selected_menu = ""
    end
  end
end
