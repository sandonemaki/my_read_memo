module ViewModel

  class BooksRandokuIndexCommon
    attr_reader :all_count, :all_randoku_state_count, :all_seidoku_state_count, :all_randoku_imgs_count,
      :randoku_history

    def initialize(all_randoku_state_books:, all_seidoku_state_books:, all_books_count:, user_books:)
      # 全てのさらさら読書画像メモの合計数
      @all_randoku_imgs_count =
      user_books.joins(:randoku_imgs).where.not(reading_state: "1").count("randoku_imgs.id")

      @all_count = all_books_count
      @all_seidoku_state_count = all_seidoku_state_books.count


      @all_randoku_state_count = all_randoku_state_books.count
      # 現在さらさら読書中の本の中からさらさら読書画像メモが多い順のbook_id。1-3位まで
      randoku_img_ranking = all_randoku_state_books.joins(:randoku_imgs)
        .group('books.id')
        .select('books.id, COUNT(randoku_imgs.id) as count')
        .order('COUNT(randoku_imgs.id) DESC').limit(3).pluck(:id)


      randoku_history = user_books.find_by(id: RandokuHistory.last.book_id) if RandokuHistory.last.present?
      #img_unread_count = randoku_history.randoku_imgs.where(reading_state: '0').count # 未読の数
      #seidoku_line_1 = (randoku_history.total_page * (1.0 / 8.0)).ceil # 切り上げ
      #seidoku_line_2 = (randoku_history.total_page * (1.0 / 4.0)).floor # 切り捨て

      # 「前回の続き」用
      # TODO: ハッシュをクラスにする
      @randoku_history =
        if randoku_history
          { id: randoku_history.id,
            title: randoku_history.title,
            cover_path: randoku_history.cover_path,
            randoku_imgs_count: randoku_history.randoku_imgs.count,
            randoku_memos_count: randoku_history.randoku_memos.count,
            seidoku_memos_count: randoku_history.seidoku_memos.count,
            reading_state: case randoku_history.reading_state
            when State::READING_STATE.key("さらさら読書：乱読")
              "さらさら読書"
            when State::READING_STATE.key("じっくり読書：精読")
              "じっくり読書"
            else
              "さらさら読書"
            end,
            path: RandokuHistory.last.path,
            randoku_history_ranking: randoku_img_ranking.include?(randoku_history.id) ?
            randoku_img_ranking.index(randoku_history.id)+1 : "",
            # 「じっくり読書」までにあと何枚画像メモを読む/足す
            remaining: randoku_history.countdown_remaining_seidoku
          }
        else
          {}
        end
    end
  end
end
