module ViewModel
  class Search
    attr_reader :selected_memos, :randoku_memo_type, :seidoku_memo_type

    def initialize(all_randoku_state_books:, all_seidoku_state_books:, content_type:,
                   randoku_memo_type:, seidoku_memo_type:)
      selected_memos =
        case content_value
        when content_value.include?("randoku")
          all_randoku_state_books.where(content_state: "#{content_type.match(/[(0-2)]/).to_s}")
        when content_value.include?("seidoku")
          all_seidoku_state_books.where(content_state: "#{content_type.match(/[(0-3)]/).to_s}")
        end
      @selected_memos =
        selected_memos.map do |memo|
          { memo_content: memo.content,
            memo_created_at: I18n.l(memo.created_at, format: :short),
            memo_content_state: book.memo.content_state,
            title: Book.find_by(id: memo.book_id).title,
            author: Book.find_by(id: memo.book_id).author_1,
            reading_state: Book.find_by(id: memo.book_id).reading_state
          }
        end
      @randoku_memo_type = randoku_memo_type
      @seidoku_memo_type = seidoku_memo_type
    end
  end
end
