module ViewModel
  class SeidokuMemoNew
    attr_reader :id, :title, :seidoku_memo_time_now, :seidoku_memo_type,
      :seidoku_memo_content_state, :seidoku_memo_content

    def initialize(book:, content_state: "", content: "")
      @id = book.id
      @titile = book.title
      @seidoku_memo_time_now = I18n.l(Time.now, format: :short)
      @seidoku_memo_type = State::SEIDOKU_MEMO_TYPE
      @seidoku_memo_content_state = content_state
      @seidoku_memo_content = content
    end
  end
end
