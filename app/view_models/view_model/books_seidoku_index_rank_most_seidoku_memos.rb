module ViewModel

  class BooksSeidokuIndexRankMostSeidokuMemos
    attr_reader :books_index_rank

    def initialize(all_seidoku_state_books:)
      # 現在精読ステータス中の本の中から精読メモの数が多い順に並べる
      most_seidoku_memos_desc_of_seidoku_state_books =
        all_seidoku_state_books.left_joins(:seidoku_memos)
        .group('books.id')
        .select('books.*, COUNT(seidoku_memos.id) as seidoku_memos_count')
        .order('seidoku_memos_count DESC')

      # 現在精読中の本の中から乱読画像が多い順のbook_id。1-3位まで
      randoku_img_ranking = all_seidoku_state_books.joins(:randoku_imgs)
        .group('books.id')
        .select('books.id, COUNT(randoku_imgs.id) as count')
        .order('COUNT(randoku_imgs.id) DESC').limit(3).pluck(:id)
      
      #TODO: ハッシュをクラスにする
      @books_index_rank =
        most_seidoku_memos_desc_of_seidoku_state_books.map do |book|
          {
            id: book.id,
            title: book.title,
            randoku_imgs_count: book.randoku_imgs.count,
            seidoku_memos_count: book.seidoku_memos.count,
            randoku_ranking: randoku_img_ranking.include?(book.id) ?
            randoku_img_ranking.index(book.id)+1 : ""
          }
        end

    end
  end
end