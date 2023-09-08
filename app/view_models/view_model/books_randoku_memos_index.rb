module ViewModel

  class BooksRandokuMemosIndex
    attr_reader :id, :title, :author, :total_page, :reading_progress,
      :seidoku_memo_key, :remaining,
      :publisher, :randoku_memos_all_count, :randoku_memos,
      :randoku_imgs_unread_count, :seidoku_line_1, :seidoku_line_2, :first_post_img_path

    def initialize(book:)
      @id = book.id
      @title = book.title
      @author = book.author_1
      @total_page = book.total_page
      @reading_progress =
        case book.reading_state
        when State::READING_STATE.key("さらさら読書：乱読")
          "さらさら読書"
        when State::READING_STATE.key("じっくり読書：精読")
          "じっくり読書"
        else
          "さらさら読書"
        end,
      (book.seidoku_memo_key = false) if @reading_progress == "じっくり読書"
      @seidoku_memo_key = book.seidoku_memo_key
      @publisher = book.publisher
      @randoku_memos_all_count = book.randoku_memos.count
      @randoku_memos =
        if book.randoku_memos.present?
          book.randoku_memos.order(updated_at: :desc).to_a.map { |memo|
            ViewModel::RandokuMemo.new(memo: memo, book: book)
          }
        end
      # じっくり読書基準に必要な変数
      randoku_imgs_group_count = book.randoku_imgs.group('reading_state').size
      @randoku_imgs_unread_count = randoku_imgs_group_count[0] ||= 0 # 未読の数
      @seidoku_line_1 = (book.total_page * (1.0 / 8.0)).ceil # 切り上げ
      @seidoku_line_2 = (book.total_page * (1.0 / 4.0)).floor # 切り捨て 
      @first_post_img_path =
              if book.randoku_imgs.exists?(first_post_flag: 1)
                "/#{book.id}/#{book.randoku_imgs.find_by(first_post_flag: 1).name}"
              else
                ""
              end

      # 「じっくり読書」までにあと何枚画像メモを読む/足す      
      @remaining = book.countdown_remaining_seidoku
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