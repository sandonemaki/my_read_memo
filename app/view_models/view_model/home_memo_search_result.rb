module ViewModel
  class HomeMemoSearchResult
    attr_reader :selected_search_value, :randoku_memo_type, :seidoku_memo_type,
      :selected_memos_count, :selected_memos, :selected_search_memo_type

    def initialize(all_randoku_state_books:, all_seidoku_state_books:,
                   randoku_memo_type:, seidoku_memo_type:, selected_search_value:)

      @selected_search_value = selected_search_value
      @randoku_memo_type = randoku_memo_type
      @seidoku_memo_type = seidoku_memo_type

      index = selected_search_value.scan(/\d+/).first.to_i
      @selected_search_memo_type =
        case selected_search_value
        when /^randoku\[\d+\]$/
          State::RANDOKU_MEMO_TYPE[index]
        when /^seidoku\[\d+\]$/
          State::SEIDOKU_MEMO_TYPE[index]
        end

      index = selected_search_value.scan(/\d+/).first.to_i
      selected_memos =
        case selected_search_value
        when /^randoku\[\d+\]$/
          all_randoku_state_books.map {|book|
            book.randoku_memos.where(content_state: index)
          }.flatten
        when /^seidoku\[\d+\]$/
          all_randoku_state_books.map {|book|
            book.seidoku_memos.where(content_state: index)
          }.flatten
        end

      @selected_memos_count = selected_memos.count || 0
      @selected_memos =
        if selected_memos.present?
          selected_memos.map { |memo|
            book = Book.find_by(id: memo.book_id)
            ViewModel::SelectedMemo.new(memo: memo, book: book)
          }
        end
    end #initialize
  end

  class SelectedMemo
    attr_reader :memo_content, :memo_created_at, :book_reading_progress,
      :book_title, :book_author, :book_id

    def initialize(memo:, book:)
      @memo_content = memo.content
      @memo_created_at = I18n.l(memo.created_at, format: :short)
      @book_reading_progress =
        case book.reading_state
        when State::READING_STATE.key("乱読")
          "乱読"
        when State::READING_STATE.key("精読")
          "精読"
        else
          "通読"
        end

      @book_title = book.title
      @book_author = book.author_1
      @book_id = book.id
    end
  end

end #ViewModel
