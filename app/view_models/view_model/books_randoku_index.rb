module ViewModel

  class BooksRandokuIndex
    attr_reader :all_count,
      :all_randoku_state_count, :all_seidoku_state_count, :all_randoku_imgs_count,
      :randoku_history,
      :imgs_desc_of_randoku_state_books, :created_imgs_desc_of_randoku_state_books,
      :created_books_desc_of_randoku_state_books

    def initialize(all_randoku_state_books:, all_seidoku_state_books:, all_books_count:)
      @all_count = all_books_count
      @all_randoku_state_count = all_randoku_state_books.count
      @all_seidoku_state_count = all_seidoku_state_books.count

      randoku_history = Book.find_by(id: RandokuHistory.last.book_id) if RandokuHistory.last.present?

      # 乱読画像が多い順のbook_id。1-3位まで
      randoku_img_ranking = Book.joins(:randoku_imgs).group('books.id')
        .select('books.id, COUNT(randoku_imgs.id) as count')
        .order('COUNT(randoku_imgs.id) DESC').limit(3).pluck(:id)



        # 「前回の続き」用
        @randoku_history =
          { titile: randoku_history.title,
            randoku_imgs_count: randoku_history.randoku_imgs.count,
            randoku_memos_count: randoku_history.randoku_memos.count,
            seidoku_memos_count: randoku_history.seidoku_memos.count,
            reading_state: case randoku_history.reading_state
            when State::READING_STATE.key("乱読")
              "乱読"
            when State::READING_STATE.key("精読")
              "精読"
            else
              "通読"
            end,
            path: RandokuHistory.last.path,
            randoku_history_ranking: randoku_img_ranking.include?(randoku_history.id) ?
            randoku_img_ranking.index(randoku_history.id)+1 : "" }
      end

      # 全ての乱読画像合計数
      @all_randoku_imgs_count =
      Book.includes(:randoku_imgs).where.not(reading_state: "1").sum("randoku_imgs.id")

      # 乱読画像が多い順
      imgs_desc_of_randoku_state_books =
        all_randoku_state_books.find(
          RandokuImg.group(:book_id).order('count(book_id) desc').pluck(:book_id)
      )
      @imgs_desc_of_randoku_state_books =
        imgs_desc_of_randoku_state_books.map do |book|
          { titile: book.title, randoku_imgs_count: book.randoku_imgs.count, randoku_memos_count: book.randoku_memos.count }
        end

      # 乱読画像の投稿順
      created_imgs_desc_of_randoku_state_books =
        all_randoku_state_books.find(
          RandokuImg.order('created_at desc').pluck(:book_id)
      )
      @created_imgs_desc_of_randoku_state_books =
        created_imgs_desc_of_randoku_state_books.map do |book|
          { titile: book.title, randoku_imgs_count: book.randoku_imgs.count, randoku_memos_count: book.randoku_memos.count }
        end

      # 乱読本の投稿順
      created_books_desc_of_randoku_state_books =
        all_randoku_state_books.find(
          Book.all.order('created_at desc').pluck(:id)
      )
      @created_books_desc_of_randoku_state_books =
        created_books_desc_of_randoku_state_books.map do |book|
          { titile: book.title, randoku_imgs_count: book.randoku_imgs.count, randoku_memos_count: book.randoku_memos.count }
        end
    end
  end
end
