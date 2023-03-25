module ViewModel
  class HomeMemoSearch
    attr_reader :randoku_memo_type, :seidoku_memo_type, :selected_memos,
      :randoku_memo_selected_menu, :seidoku_memo_selected_menu

    def initialize(randoku_memo_type:, seidoku_memo_type:)
      @randoku_memo_type = randoku_memo_type
      @seidoku_memo_type = seidoku_memo_type
      @selected_memos = []
      @randoku_memo_selected_menu = ""
      @seidoku_memo_selected_menu = ""
    end
  end
end
