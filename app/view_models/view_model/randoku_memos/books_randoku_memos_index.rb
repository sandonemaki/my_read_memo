module ViewModel

  class BooksRandokuMemosIndex
    attr_reader :id, :title, :author_1, :reading_state, :publisher,
      :randoku_img_read_again_count, :randoku_img_finish_read_count,
      :randoku_img_first_post_filename,
      :randoku_memos_all, :randoku_memos_all_asc, :randoku_memos_all_count

    def initialize(book:, randoku_img_first_post_filename:)
      @id = book.id
      @title = book.title
      @author_1 = book.author_1
      @reading_state =
        case book.reading_state
        when State::READING_STATE.key("乱読")
          "乱読"
        when State::READING_STATE.key("精読")
          "精読"
        else
          "通読"
        end
      @publisher = book.publisher

      reading_state = book.randoku_imgs.group('reading_state').size
      @randoku_img_read_again_count  = reading_state[0] ||= 0 # 未読の数(0)
      @randoku_img_finish_read_count = reading_state[1] ||= 0 # 既読の数(0)
      @randoku_img_first_post_filename = randoku_img_first_post_filename
      @randoku_memos_all_count = book.randoku_memos.all.size
      @randoku_memos_all = book.randoku_memos.all.order(created_at: :desc).to_a.map { |randoku_memo|
        { content: randoku_memo.content, created_at: I18n.l(randoku_memo.created_at, format: :short),
          content_state: book.randoku_memos.content_state == 0 ?
            RANDOKU_MEMO_Q[0] : RANDOKU_MEMO_BKG[book.randoku_memos.content_state] }
      }
      @randoku_memos_all_asc = book.randoku_memos.all.order(created_at: :asc).to_a.map { |randoku_memo|
        { content: randoku_memo.content, created_at: I18n.l(randoku_memo.created_at, format: :short),
          content_state: book.randoku_memos.content_state == 0 ?
            RANDOKU_MEMO_Q[0] : RANDOKU_MEMO_BKG[book.randoku_memos.content_state] }
      }
    end
  end
end
