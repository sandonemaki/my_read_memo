module ViewModel

  class BooksSeidokuIndexRankCreatedBooks
    attr_reader :books_index_rank

    def initialize(all_seidoku_state_books:)
      # 精読本の投稿順
      created_books_desc_of_seidoku_state_books =
        all_seidoku_state_books.order(created_at: :desc)

      #TODO: ハッシュをクラスにする
      @books_index_rank =
        created_books_desc_of_seidoku_state_books.map do |book|
          {
            titile: book.title,
            randoku_imgs_count: book.randoku_imgs.count,
            seidoku_memos_count: book.seidoku_memos.count
          }
        end
    end
  end
end
