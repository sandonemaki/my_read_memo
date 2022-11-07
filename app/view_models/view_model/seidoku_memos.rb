module ViewModel
  class SeidokuMemos
    attr_reader :id, :title, :author_1, :reading_state, :publisher,
      :seidoku_memos_all_count, :seidoku_memos_all, :seidoku_memos_all_asc,
      :seidoku_memo_author_opinion, :seidoku_memo_my_opinion

    def initialize(book:)
      @id = book.id
      @title = book.title
      @author_1 = book.author_1
      @reading_state =
        case book.reading_state
        when State::READING_STATE.key("乱読")
          "乱読"
        when State::READING_STATE.key("精読")
          "精読"
        else
          "通読"
        end
      @publisher = book.publisher

      content_state = book.seidoku_memos.group('content_state').size
      @seidoku_memo_author_opinion = content_state[1] ||= 0 # 著者の意見数
      @seidoku_memo_my_opinion     = content_state[3] ||= 0 # 自分の意見数
      @seidoku_memos_all_count = book.seidoku_memos.all.size
      @seidoku_memos_all = book.seidoku_memos.all.order(created_at: :desc).to_a.map { |seidoku_memo|
        { content: seidoku_memo.content, created_at: I18n.l(seidoku_memo.created_at, format: :short),
          content_state: SEIDOKU_MEMO_TYPE[seidoku_memo.content_state] }
      }
      @seidoku_memos_all_asc = book.seidoku_memos.all.order(created_at: :asc).to_a.map { |seidoku_memo|
        { content: seidoku_memo.content, created_at: I18n.l(seidoku_memo.created_at, format: :short),
          content_state: SEIDOKU_MEMO_TYPE[seidoku_memo.content_state] }
      }
    end
  end
end

