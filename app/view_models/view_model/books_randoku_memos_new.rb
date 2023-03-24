module ViewModel
  class BooksRandokuMemosNew
    attr_reader :id, :title, :randoku_memo_time_now, :randoku_memo_q, :randoku_memo_bkg,
      :randoku_memo_selected_content_type, :randoku_memo_content, :randoku_memo_errors

    def initialize(book:, selected_content_type: nil, randoku_memo_content: "")
      @id = book.id
      @title = book.title

      @randoku_memo_time_now = I18n.l(Time.now, format: :short)
      @randoku_memo_q = State::RANDOKU_MEMO_Q
      @randoku_memo_bkg = State::RANDOKU_MEMO_BKG
      # String セレクトボックのparams[:value].first
      @randoku_memo_selected_content_type = selected_content_type
      @randoku_memo_content = randoku_memo_content
      @randoku_memo_errors = book.randoku_memos.last&.errors || {}
    end
  end
end
