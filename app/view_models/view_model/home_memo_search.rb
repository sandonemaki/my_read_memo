module ViewModel
  class HomeMemoSearch
    attr_reader :randoku_memo_type, :seidoku_memo_type, :selected_memos

    def initialize(randoku_memo_type:, seidoku_memo_type:)
      @randoku_memo_type = randoku_memo_type
      @seidoku_memo_type = seidoku_memo_type
      @selected_memos = []
    end
  end
end
