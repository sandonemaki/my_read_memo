module ViewModel

  class BooksRandokuIndexRankCreatedImgs
    attr_reader :books_index_rank, :rank_title

    def initialize(all_randoku_state_books:)
      @rank_title = "さらさら読書画像メモの投稿順"

      # さらさら読書画像メモの投稿順
      created_imgs_desc_of_randoku_state_books =
        all_randoku_state_books.joins(:randoku_imgs)
        .select('books.*, MAX(randoku_imgs.created_at) as latest_randoku_img_time')
        .group('books.id')
        .order('latest_randoku_img_time DESC')

      # 現在さらさら読書中の本の中からさらさら読書画像メモが多い順のbook_id。1-3位まで
      randoku_img_ranking = all_randoku_state_books.joins(:randoku_imgs)
        .group('books.id')
        .select('books.id, COUNT(randoku_imgs.id) as count')
        .order('COUNT(randoku_imgs.id) DESC').limit(3).pluck(:id)

      #TODO: ハッシュをクラスにする
      @books_index_rank =
        created_imgs_desc_of_randoku_state_books.map do |book|
          img_unread_count = book.randoku_imgs.where(reading_state: '0').count # 未読の数
          seidoku_line_1 = (book.total_page * (1.0 / 8.0)).ceil # 切り上げ
          seidoku_line_2 = (book.total_page * (1.0 / 4.0)).floor # 切り捨て  
          {
            id: book.id,
            title: book.title,
            cover_path: book.cover_path,
            randoku_imgs_count: book.randoku_imgs.count,
            randoku_memos_count: book.randoku_memos.count,
            reading_state: case book.reading_state
            when State::READING_STATE.key("さらさら読書：乱読")
              "さらさら読書"
            when State::READING_STATE.key("じっくり読書：精読")
              "じっくり読書"
            else
              "さらさら読書"
            end,
            randoku_ranking: randoku_img_ranking.include?(book.id) ?
            randoku_img_ranking.index(book.id)+1 : "",
            # 「じっくり読書」までにあと何枚さらさら読書画像メモを読む/足す
            remaining: book.countdown_remaining_seidoku
          }
        end

    end
  end
end
