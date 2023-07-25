module ViewModel

  class BooksRandokuIndexRankMostImgs
    attr_reader :books_index_rank, :rank_title

    def initialize(all_randoku_state_books:)
      @rank_title = "乱読画像の多い順"
      # 現在乱読ステータス中の本の中から乱読画像が多い順に並べる
      most_imgs_desc_of_randoku_state_books =
        all_randoku_state_books.left_joins(:randoku_imgs)
        .group('books.id')
        .select('books.*, COUNT(randoku_imgs.id) as randoku_imgs_count')
        .order('randoku_imgs_count DESC')
      
      # 現在乱読中の本の中から乱読画像が多い順のbook_id。1-3位まで
      randoku_img_ranking = all_randoku_state_books.joins(:randoku_imgs)
      .group('books.id')
      .select('books.id, COUNT(randoku_imgs.id) as count')
      .order('COUNT(randoku_imgs.id) DESC').limit(3).pluck(:id)

      #TODO: ハッシュをクラスにする
      @books_index_rank =
        most_imgs_desc_of_randoku_state_books.map do |book|
          #img_unread_count = book.randoku_imgs.where(reading_state: '0').count # 未読の数
          #seidoku_line_1 = (book.total_page * (1.0 / 8.0)).ceil # 切り上げ
          #seidoku_line_2 = (book.total_page * (1.0 / 4.0)).floor # 切り捨て 
          {
            id: book.id,
            title: book.title,
            randoku_imgs_count: book.randoku_imgs.count,
            randoku_memos_count: book.randoku_memos.count,
            reading_state: case book.reading_state
            when State::READING_STATE.key("乱読")
              "乱読"
            when State::READING_STATE.key("精読")
              "精読"
            else
              "通読"
            end,
            randoku_ranking: randoku_img_ranking.include?(book.id) ?
            randoku_img_ranking.index(book.id)+1 : "",
            # 精読まで未読をあと何枚
            remaining: book.countdown_remaining_seidoku
          }
        end

      
    end
  end
end
