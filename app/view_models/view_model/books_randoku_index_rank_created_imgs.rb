module ViewModel

  class BooksRandokuIndexRankCreatedImgs
    attr_reader :books_index_rank

    def initialize(all_randoku_state_books:)

      # 乱読画像の投稿順
      created_imgs_desc_of_randoku_state_books =
        all_randoku_state_books.joins(:randoku_imgs)
        .select('books.*, MAX(randoku_imgs.created_at) as latest_randoku_img_time')
        .group('books.id')
        .order('latest_randoku_img_time DESC')

      #TODO: ハッシュをクラスにする
      @books_index_rank =
        created_imgs_desc_of_randoku_state_books.map do |book|
          img_unread_count = book.randoku_imgs.where(reading_state: '0').count # 未読の数
          seidoku_line_1 = (book.total_page * (1.0 / 8.0)).ceil # 切り上げ
          seidoku_line_2 = (book.total_page * (1.0 / 4.0)).floor # 切り捨て  
          {
            id: book.id,
            title: book.title,
            randoku_imgs_count: book.randoku_imgs.count,
            randoku_memos_count: book.randoku_memos.count,
            # 精読まで未読をあと何枚
            remaining: book.countdown_remaining_seidoku
          }
        end

    end
  end
end
