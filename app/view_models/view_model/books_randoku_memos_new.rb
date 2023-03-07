module ViewModel
  class BooksRandokuMemosNew
    attr_reader :id, :title, :randoku_memo_time_now, :randoku_memo_q, :randoku_memo_bkg,
      :randoku_memo_content_state, :randoku_memo_content

    def initialize(book:, content_state: "", content: "")
      @id = book.id
      @title = book.title

      @randoku_memo_time_now = I18n.l(Time.now, format: :short)
      @randoku_memo_q = State::RANDOKU_MEMO_Q
      @randoku_memo_bkg = State::RANDOKU_MEMO_BKG
      @randoku_memo_content_state = content_state
      @randoku_memo_content = content
    end
  end
end
