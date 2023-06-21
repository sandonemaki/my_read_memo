module ViewModel

  class BooksRandokuIndexRankCreatedBooks
    attr_reader :books_index_rank

    def initialize(all_randoku_state_books:)

      # 乱読本の投稿順
      created_books_desc_of_randoku_state_books =
        all_randoku_state_books.order(created_at: :desc)

      # 現在乱読中の本の中から乱読画像が多い順のbook_id。1-3位まで
      randoku_img_ranking = all_randoku_state_books.joins(:randoku_imgs)
        .group('books.id')
        .select('books.id, COUNT(randoku_imgs.id) as count')
        .order('COUNT(randoku_imgs.id) DESC').limit(3).pluck(:id)
      
      #TODO: ハッシュをクラスにする
      @books_index_rank =
        created_books_desc_of_randoku_state_books.map do |book|
          {
            title: book.title,
            randoku_imgs_count: book.randoku_imgs.count,
            randoku_memos_count: book.randoku_memos.count,
            reading_state: case book.reading_state
            when State::READING_STATE.key("乱読")
              "乱読"
            when State::READING_STATE.key("精読")
              "精読"
            else
              "通読"
            end,
            randoku_ranking: randoku_img_ranking.include?(book.id) ?
            randoku_img_ranking.index(book.id)+1 : ""
          }
        end
    end
  end
end