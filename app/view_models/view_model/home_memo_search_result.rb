module ViewModel
  # todo:要挙動確認。view_modelではなくクラス化必要?
  class HomeMemoSearchResult
    attr_reader :selected_search_value, :randoku_memo_type, :seidoku_memo_type,
      :selected_memos_count, :selected_memos

    def initialize(all_randoku_state_books:, all_seidoku_state_books:,
                   randoku_memo_type:, seidoku_memo_type:, selected_search_value:)

      @selected_search_value = selected_search_value
      @randoku_memo_type = randoku_memo_type
      @seidoku_memo_type = seidoku_memo_type

      selected_memos =
        case selected_search_value
        when /^randoku\[\d+\]$/
          index = selected_search_value.scan(/\d+/).first.to_i
          all_randoku_state_books.map {|book|
            book.randoku_memos.where(content_state: index)
          }.flatten
        when /^seidoku\[\d+\]$/
          index = selected_search_value.scan(/\d+/).first.to_i
          all_randoku_state_books.map {|book|
            book.seidoku_memos.where(content_state: index)
          }.flatten
        end

      @selected_memos_count = selected_memos&.count || 0
      @selected_memos =
        if selected_memos.present?
          selected_memos.map { |memo|
            ViewModel::SelectedMemo.new(memo: memo, book: Book.find_by(id: memo.book_id))
          }
        end
    end #initialize
  end

  class SelectedMemo
    attr_reader :memo_content, :memo_created_at, :book_reading_progress,
      :memo_content_type, :book_title, :book_author

    def initialize(memo:, book:)
      @memo_content = memo.content
      @memo_created_at = I18n.l(memo.created_at, format: :short)
      @book_reading_progress = book.reading_state
      @memo_content_type =
        # TODO: intではなくモデリング名を使用する
        if ['0', '2'].include?(@reading_progress)
          State::RANDOKU_MEMO_TYPE[memo.content_state]
        else
          State::SEIDOKU_MEMO_TYPE[memo.content_state]
        end
      @book_title = book.title
      @book_author = book.author_1
    end
  end

end #ViewModel
