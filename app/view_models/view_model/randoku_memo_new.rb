module ViewModel
  class RandokuMemoNew
    attr_reader :id, :title, :randoku_memo_time_now, :randoku_memo_q, :randoku_memo_bkg,
      :randoku_memo_content_state, :randoku_memo_content

    def initialize(book:, time_now:)
      @id = book.id
      @title = book.title

      @randoku_memo_time_now = time_now
      @randoku_memo_q = State::RANDOKU_MEMO_Q
      @randoku_memo_bkg = State::RANDOKU_MEMO_BKG
      @randoku_memo_content_state =
        content_state ||= ""
      # @randoku_memo_content = book.randoku_memos.content
    end
  end
end
