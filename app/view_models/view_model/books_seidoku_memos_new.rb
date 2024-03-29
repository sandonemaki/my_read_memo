module ViewModel
  class BooksSeidokuMemosNew
    attr_reader :id, :title, :seidoku_memo_time_now, :seidoku_memo_type,
      :seidoku_memo_selected_content_type, :seidoku_memo_content, :seidoku_memo_errors

    def initialize(book:, selected_content_type: nil, seidoku_memo_content: "")
      @id = book.id
      @title = book.title
      @seidoku_memo_time_now = I18n.l(Time.now, format: :short)
      @seidoku_memo_type = State::SEIDOKU_MEMO_TYPE
      # String セレクトボックのparams[:value].first
      @seidoku_memo_selected_content_type = selected_content_type
      @seidoku_memo_content = seidoku_memo_content
      @seidoku_memo_errors = book.seidoku_memos.last&.errors || {}
    end
  end
end