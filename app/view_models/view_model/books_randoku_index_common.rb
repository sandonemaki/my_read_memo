module ViewModel

  class BooksRandokuIndexCommon
    attr_reader :all_count,
      :all_randoku_state_count, :all_seidoku_state_count, :all_randoku_imgs_count,
      :randoku_history

    def initialize(all_randoku_state_books:, all_seidoku_state_books:, all_books_count:)
      # 全ての乱読画像合計数
      @all_randoku_imgs_count =
      Book.joins(:randoku_imgs).where.not(reading_state: "1").count("randoku_imgs.id")

      @all_count = all_books_count
      @all_seidoku_state_count = all_seidoku_state_books.count


      @all_randoku_state_count = all_randoku_state_books.count
      # 現在乱読中の本の中から乱読画像が多い順のbook_id。1-3位まで
      randoku_img_ranking = all_randoku_state_books.joins(:randoku_imgs)
        .group('books.id')
        .select('books.id, COUNT(randoku_imgs.id) as count')
        .order('COUNT(randoku_imgs.id) DESC').limit(3).pluck(:id)


      randoku_history = Book.find_by(id: RandokuHistory.last.book_id) if RandokuHistory.last.present?
      #img_unread_count = randoku_history.randoku_imgs.where(reading_state: '0').count # 未読の数
      #seidoku_line_1 = (randoku_history.total_page * (1.0 / 8.0)).ceil # 切り上げ
      #seidoku_line_2 = (randoku_history.total_page * (1.0 / 4.0)).floor # 切り捨て

      # 「前回の続き」用
      # TODO: ハッシュをクラスにする
      @randoku_history =
        if randoku_history
          { id: randoku_history.id,
            title: randoku_history.title,
            randoku_imgs_count: randoku_history.randoku_imgs.count,
            randoku_memos_count: randoku_history.randoku_memos.count,
            seidoku_memos_count: randoku_history.seidoku_memos.count,
            reading_state: case randoku_history.reading_state
            when State::READING_STATE.key("乱読")
              "乱読"
            when State::READING_STATE.key("精読")
              "精読"
            else
              "通読"
            end,
            path: RandokuHistory.last.path,
            randoku_history_ranking: randoku_img_ranking.include?(randoku_history.id) ?
            randoku_img_ranking.index(randoku_history.id)+1 : "",
            # 精読まで未読をあと何枚
            remaining: randoku_history.countdown_remaining_seidoku
          }
        else
          {}
        end
    end
  end
end
