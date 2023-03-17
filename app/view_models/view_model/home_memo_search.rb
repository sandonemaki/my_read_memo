module ViewModel
  # todo:要挙動確認。view_modelではなくクラス化必要?
  class HomeMemoSearch
    attr_reader :selected_memos_count, :randoku_memo_type, :seidoku_memo_type, :selected_memos

    def initialize(all_randoku_state_books:, all_seidoku_state_books:, content_type:,
                   randoku_memo_type:, seidoku_memo_type:)
      # params[value]
      @content_type = content_type
      @randoku_memo_type = randoku_memo_type
      @seidoku_memo_type = seidoku_memo_type

      selected_memos =
      case @content_type[0]
      when /^randoku\[\d+\]$/
        index = @content_type[0].scan(/\d+/).first.to_i
        all_randoku_state_books.map {|book|
          book.randoku_memos.where(content_state: index)
        }.flatten
      when /^seidoku\[\d+\]$/
        index = @content_type[0].scan(/\d+/).first.to_i
        all_randoku_state_books.map {|book|
          book.seidoku_memos.where(content_state: index)
        }.flatten
      end

      @selected_memos_count = selected_memos.count || 0
      @selected_memos =
        if seleted_memos.present?
          selected_memos.map { |memo|
            book = Book.find_by(id: memo.book_id)
            ViewModel::SelectedMemo.new(memo: memo, book: book)
          }
        end
    end #initialize
  end

  class SelectedMemo
    attr_reader :content, :created_at, :book_reading_progress, :content_type,
      :book_title, :book_author

    def initialize(memo:, book:)
      @content = memo.content
      @created_at = I18n.l(memo.created_at, format: :short)
      @book_reading_progress = book.reading_state
      @content_type =
        if ['0', '2'].include?(@reading_progress)
          RANDOKU_MEMO_TYPE[memo.content_state]
        else
          SEIDOKU_MEMO_TYPE[memo.content_state]
        end
      @book_title = book.title
      @book_author = book.author_1
    end
  end

end
