module ViewModel

  class BooksRandokuMemosIndex
    attr_reader :id, :title, :author, :total_page, :reading_progress,
      :publisher, :randoku_memos_count, :randoku_memos

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
      @randoku_memos_count = book.randoku_memos.count
      @randoku_memos =
        if book.randoku_memos.present?
          book.randoku_memos.order(updated_at: :desc).to_a.map { |memo|
            ViewModel::RandokuMemo.new(memo: memo, book: book)
          }
        end
    end #initialize
  end

  class RandokuMemo
    attr_reader :memo_content, :memo_created_at, :memo_content_type,
      :book_title, :book_author, :book_id

    def initialize(memo:, book:)
      @memo_content = memo.content
      @memo_created_at = I18n.l(memo.created_at, format: :short)
      @memo_content_type =
        # TODO: intではなくモデリング名を使用する
        if ['0', '2'].include?(book.reading_state.to_s)
          State::RANDOKU_MEMO_TYPE[memo.content_state]
        else
          State::SEIDOKU_MEMO_TYPE[memo.content_state]
        end
    end
  end
end #ViewModel
