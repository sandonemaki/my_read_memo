module ViewModel

  class BooksSeidokuIndexRankCreatedBooks
    attr_reader :books_index_rank, :rank_title

    def initialize(all_seidoku_state_books:)
      @rank_title = "じっくり読書本の投稿順"
      # じっくり読書本の投稿順
      created_books_desc_of_seidoku_state_books =
        all_seidoku_state_books.order(created_at: :desc)
      
      # 現在さらさら読書中の本の中からさらさら読書画像メモが多い順のbook_id。1-3位まで
      randoku_img_ranking = all_seidoku_state_books.joins(:randoku_imgs)
      .group('books.id')
      .select('books.id, COUNT(randoku_imgs.id) as count')
      .order('COUNT(randoku_imgs.id) DESC').limit(3).pluck(:id)

      #TODO: ハッシュをクラスにする
      @books_index_rank =
        created_books_desc_of_seidoku_state_books.map do |book|
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