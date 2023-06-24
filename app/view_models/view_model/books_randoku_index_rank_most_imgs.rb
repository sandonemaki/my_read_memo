module ViewModel

  class BooksRandokuIndexRankMostImgs
    attr_reader :books_index_rank

    def initialize(all_randoku_state_books:)
      # 現在乱読ステータス中の本の中から乱読画像が多い順に並べる
      most_imgs_desc_of_randoku_state_books =
        all_randoku_state_books.joins(:randoku_imgs)
        .group('books.id')
        .select('books.*, COUNT(randoku_imgs.id) as randoku_imgs_count')
        .order('randoku_imgs_count DESC')

      #TODO: ハッシュをクラスにする
      @books_index_rank =
        most_imgs_desc_of_randoku_state_books.map do |book|
          {
            title: book.title,
            randoku_imgs_count: book.randoku_imgs.count,
            randoku_memos_count: book.randoku_memos.count
          }
        end

      
    end
  end
end
