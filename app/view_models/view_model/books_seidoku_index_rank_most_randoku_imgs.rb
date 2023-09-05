module ViewModel

  class BooksSeidokuIndexRankMostRandokuImgs
    attr_reader :books_index_rank, :rank_title

    def initialize(all_seidoku_state_books:)
      @rank_title = "さらさら読書画像メモの多い順"
      # 現在じっくり読書ステータス中の本の中からさらさら読書画像メモの数が多い順に並べる
      most_randoku_memos_desc_of_seidoku_state_books =
        all_seidoku_state_books.joins(:randoku_imgs)
        .group('books.id')
        .select('books.*, COUNT(randoku_imgs.id) as randoku_imgs_count')
        .order('randoku_imgs_count DESC')

      # 現在じっくり読書中の本の中からさらさら読書画像メモが多い順のbook_id。1-3位まで
      randoku_img_ranking = all_seidoku_state_books.joins(:randoku_imgs)
        .group('books.id')
        .select('books.id, COUNT(randoku_imgs.id) as count')
        .order('COUNT(randoku_imgs.id) DESC').limit(3).pluck(:id)
      
      #TODO: ハッシュをクラスにする
      @books_index_rank =
        most_randoku_memos_desc_of_seidoku_state_books.map do |book|
          {
            id: book.id,
            title: book.title,
            cover_path: book.cover_path,
            randoku_imgs_count: book.randoku_imgs.count,
            seidoku_memos_count: book.seidoku_memos.count,
            randoku_ranking: randoku_img_ranking.include?(book.id) ?
            randoku_img_ranking.index(book.id)+1 : ""
          }
        end

    end
  end
end