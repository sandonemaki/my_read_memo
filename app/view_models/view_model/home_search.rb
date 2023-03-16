module ViewModel
  class Search
    attr_reader :selected_memos, :selected_memos_count, :randoku_memo_type, :seidoku_memo_type

    def initialize(all_randoku_state_books:, all_seidoku_state_books:, content_type:,
                   randoku_memo_type:, seidoku_memo_type:)
      selected_memos =
        case content_value
        when content_value.include?("randoku")
          all_randoku_state_books.where(content_state: "#{content_type.match(/[(0-2)]/).to_s}")
        when content_value.include?("seidoku")
          all_seidoku_state_books.where(content_state: "#{content_type.match(/[(0-3)]/).to_s}")
        end
      @selected_memos_count = selected_memos.count
      @selected_memos =
        selected_memos.map do |memo|
          reading_progress = Book.find_by(id: memo.book_id).reading_state
          { content: memo.content,
            created_at: I18n.l(memo.created_at, format: :short),
            content_state: book_reading_state == 0 || 2 ?
            randoku_memo_type[memo.content_state] : seidoku_memo_type[memo.content_state]
            book_title: Book.find_by(id: memo.book_id).title,
            book_author: Book.find_by(id: memo.book_id).author_1,
            book_reading_progress: reading_progress
          }
        end
      @randoku_memo_type = randoku_memo_type
      @seidoku_memo_type = seidoku_memo_type
    end
  end
end
