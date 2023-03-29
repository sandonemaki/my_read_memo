module ViewModel

  class BooksSeidokuMemosIndex
    attr_reader :id, :title, :author, :total_page, :reading_progress,
      :publisher, :seidoku_memo_author_opinion_count, :seidoku_memo_my_opinion_count,
      :seidoku_memos_all_count, :seidoku_memos

    def initialize(book:)
      @id = book.id
      @title = book.title
      @author = book.author_1
      @total_page = book.total_page
      @reading_progres =
        case book.reading_state
        when State::READING_STATE.key("乱読")
          "乱読"
        when State::READING_STATE.key("精読")
          "精読"
        else
          "通読"
        end
      @publisher = book.publisher

      author_opinion_index = State::SEIDOKU_MEMO_TYPE.key("著者の意見")
      @seidoku_memo_author_opinion_count = book.seidoku_memos.where(content_state: author_opinion_index).count
      my_opinion_index = State::SEIDOKU_MEMO_TYPE.key("自分の意見")
      @seidoku_memo_my_opinion_count = book.seidoku_memos.where(content_state: my_opinion_index).count

      @seidoku_memos_all_count = book.seidoku_memos.count
      @seidoku_memos =
        if book.seidoku_memos.present?
          book.seidoku_memos.order(updated_at: :desc).to_a.map { |memo|
            ViewModel::SeidokuMemo.new(memo: memo, book: book)
          }
        end
    end #initialize
  end

  class SeidokuMemo
    attr_reader :content, :created_at, :content_type

    def initialize(memo:, book:)
      @content = memo.content
      @created_at = I18n.l(memo.created_at, format: :short)
      @content_type = State::SEIDOKU_MEMO_TYPE[memo.content_state]
    end
  end
end #ViewModel
