module ViewModel
  class BooksSeidokuMemosNew
    attr_reader :id, :title, :seidoku_memo_time_now, :seidoku_memo_type,
      :seidoku_memo_content_type, :seidoku_memo_content

    def initialize(book:, seidokumemo_content_type: nil, seidokumemo_content: "")
      @id = book.id
      @titile = book.title
      @seidoku_memo_time_now = I18n.l(Time.now, format: :short)
      @seidoku_memo_type = State::SEIDOKU_MEMO_TYPE
      # String セレクトボックのparams[:value].first
      @seidoku_memo_content_type = seidokumemo_content_type
      @seidoku_memo_content = seidokumemo_content
    end
  end
end
