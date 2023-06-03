module ViewModel

  class BooksSeidokuIndexRankMostRandokuImgs
    attr_reader :books_index_rank

    def initialize(all_seidoku_state_books:)
      # 現在精読ステータス中の本の中から精読メモの数が多い順に並べる
      most_randoku_memos_desc_of_seidoku_state_books =
        all_seidoku_state_books.joins(:randoku_imgs)
        .group('books.id')
        .select('books.*, COUNT(randoku_imgs.id) as randoku_imgs_count')
        .order('randoku_imgs_count DESC')

      #TODO: ハッシュをクラスにする
      @books_index_rank =
        most_randoku_memos_desc_of_seidoku_state_books.map do |book|
          {
            titile: book.title,
            randoku_imgs_count: book.randoku_imgs.count,
            seidoku_memos_count: book.seidoku_memos.count
          }
        end

    end
  end
end