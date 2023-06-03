module ViewModel

  class BooksRandokuIndexRankCreatedBooks
    attr_reader :books_index_rank

    def initialize(all_randoku_state_books:)

      # 乱読本の投稿順
      created_books_desc_of_randoku_state_books =
        all_randoku_state_books.order(created_at: :desc)
      #TODO: ハッシュをクラスにする
      @books_index_rank =
        created_books_desc_of_randoku_state_books.map do |book|
          {
            titile: book.title,
            randoku_imgs_count: book.randoku_imgs.count,
            randoku_memos_count: book.randoku_memos.count
          }
        end
    end
  end
end
