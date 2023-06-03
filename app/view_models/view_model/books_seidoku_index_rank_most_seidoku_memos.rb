module ViewModel

  class BooksSeidokuIndexRankMostSeidokuMemos
    attr_reader :books_index_rank

    def initialize(all_seidoku_state_books:)
      # 現在精読ステータス中の本の中から精読メモの数が多い順に並べる
      most_seidoku_memos_desc_of_seidoku_state_books =
        all_seidoku_state_books.joins(:seidoku_memos)
        .group('books.id')
        .select('books.*, COUNT(seidoku_memos.id) as seidoku_memos_count')
        .order('seidoku_memos_count DESC')

      #TODO: ハッシュをクラスにする
      @books_index_rank =
        most_seidoku_memos_desc_of_seidoku_state_books.map do |book|
          {
            titile: book.title,
            randoku_imgs_count: book.randoku_imgs.count,
            seidoku_memos_count: book.seidoku_memos.count
          }
        end

    end
  end
end
