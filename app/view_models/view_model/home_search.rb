module ViewModel
  class HomeSearch
    attr_reader :selected_memos, :selected_memos_count, :randoku_memo_type, :seidoku_memo_type

    def initialize(all_randoku_state_books:, all_seidoku_state_books:, content_type:,
                   randoku_memo_type:, seidoku_memo_type:)
      @content_type = content_type
      @randoku_memo_type = randoku_memo_type
      @seidoku_memo_type = seidoku_memo_type
      selected_memos =
        case @content_type[0]
        when /^randoku\[\d+\]$/
          index = @content_type[0]&.scan(/\d+/)&.first&.to_i
          all_randoku_state_books.map {|book|
            book.randoku_memos.where(content_state: index)
          }.flatten
        when /^seidoku\[\d+\]$/
          index = @content_type[0]&.scan(/\d+/)&.first&.to_i
          all_randoku_state_books.map {|book|
            book.seidoku_memos.where(content_state: index)
          }.flatten
        end || []
      @selected_memos_count = selected_memos.count || 0
      @selected_memos =
        selected_memos&.map do |memo|
          book = Book.find_by(id: memo.book_id)
          reading_progress = book.reading_state || 0
          # TODO: hashをクラスにする
          { content: memo.content,
            created_at: I18n.l(memo.created_at, format: :short),
            # TODO: reading_state 0,2 を文字列から数字に詰め替えるメソッドで表現する
            content_state:
              if ['0', '2'].include?(reading_progress)
                RANDOKU_MEMO_TYPE[memo.content_state]
              else
                SEIDOKU_MEMO_TYPE[memo.content_state]
              end
            book_title: book.title,
            book_author: book.author_1,
            book_reading_progress: reading_progress
          }
        end || []
      end
  end
end
