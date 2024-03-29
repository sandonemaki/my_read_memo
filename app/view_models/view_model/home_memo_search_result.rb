module ViewModel
  class HomeMemoSearchResult
    attr_reader :selected_search_value, :randoku_memo_type, :seidoku_memo_type,
      :selected_memos_count, :selected_memos, :selected_search_memo_type

    def initialize(all_books:, randoku_memo_type:, seidoku_memo_type:, selected_search_value:, user_books:)

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
          all_books.map {|book|
            book.randoku_memos.where(content_state: index)
          }.flatten
        when /^seidoku\[\d+\]$/
          all_books.map {|book|
            book.seidoku_memos.where(content_state: index)
          }.flatten
        end

      @selected_memos_count = selected_memos.count || 0
      @selected_memos =
        if selected_memos.present?
          selected_memos.map { |memo|
            book = user_books.find_by(id: memo.book_id)
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
        when State::READING_STATE.key("さらさら読書：乱読")
          "さらさら読書"
        when State::READING_STATE.key("じっくり読書：精読")
          "じっくり読書"
        else
          "さらさら読書"
        end

      @book_title = book.title
      @book_author = book.author_1
      @book_id = book.id
    end
  end

end #ViewModel
