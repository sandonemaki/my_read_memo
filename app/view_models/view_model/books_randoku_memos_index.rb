module ViewModel

  class BooksRandokuMemosIndex
    attr_reader :id, :title, :author, :total_page, :reading_progress,
      :publisher, :randoku_memos_all_count, :randoku_memos

    def initialize(book:)
      @id = book.id
      @title = book.title
      @author = book.author_1
      @total_page = book.total_page
      @reading_progress =
        case book.reading_state
        when State::READING_STATE.key("乱読")
          "乱読"
        when State::READING_STATE.key("精読")
          "精読"
        else
          "通読"
        end
      @publisher = book.publisher
      @randoku_memos_all_count = book.randoku_memos.count
      @randoku_memos =
        if book.randoku_memos.present?
          book.randoku_memos.order(updated_at: :desc).to_a.map { |memo|
            ViewModel::RandokuMemo.new(memo: memo, book: book)
          }
        end
    end #initialize
  end

  class RandokuMemo
    attr_reader :content, :created_at, :content_type

    def initialize(memo:, book:)
      @content = memo.content
      @created_at = I18n.l(memo.created_at, format: :short)
      @content_type = State::RANDOKU_MEMO_TYPE[memo.content_state]
    end
  end
end #ViewModel
