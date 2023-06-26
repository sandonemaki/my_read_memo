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
          {
            id: book.id,
            title: book.title,
            randoku_imgs_count: book.randoku_imgs.count,
            randoku_memos_count: book.randoku_memos.count
          }
        end

    end
  end
end
