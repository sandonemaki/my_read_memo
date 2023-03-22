module ViewModel
  class HomeSearch
    attr_reader :selected_memos, :selected_memos_count, :randoku_memo_type, :seidoku_memo_type

    def initialize(all_randoku_state_books:, all_seidoku_state_books:, content_type:,
                   randoku_memo_type:, seidoku_memo_type:)
      # TODO: 変数content_typeがコメントがないとわかり辛いので修正
      @content_type = content_type # params[:value] セレクトボックス選択値
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
          mbook = Book.find_by(id: memo.book_id)
          reading_progress = mbook.reading_state
          #TODO: hashをクラスにする
          { content: memo.content,
            created_at: I18n.l(memo.created_at, format: :short),
            content_state:
              # TODO: 数字ではなくドメイン名を使用する
              if ['0', '2'].include?(reading_progress)
                RANDOKU_MEMO_TYPE[memo.content_state]
              else
                SEIDOKU_MEMO_TYPE[memo.content_state]
              end
            book_title: book.title,
            book_author: book.author_1,
            book_reading_progress: reading_progress
          }
        }
      end

    end #initialize
  end
end
