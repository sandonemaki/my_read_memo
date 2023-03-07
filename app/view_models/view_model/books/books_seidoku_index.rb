module ViewModel

  class BooksSeidokuIndex
    attr_reader :all_count,
      :all_randoku_state_count, :all_seidoku_state_count, :all_randoku_imgs_count,
      :seidoku_history,
      :seidoku_memos_desc_of_seidoku_state_books, :created_seidoku_memos_desc_of_seidoku_state_books,
      :created_books_desc_of_seidoku_state_books

    def initialize(all_randoku_state_books:, all_seidoku_state_books:, all_books_count:)
      @all_count = all_books_count
      @all_randoku_state_count = all_randoku_state_books.count
      @all_seidoku_state_count = all_seidoku_state_books.count

      if SeidokuHistory.last
        seidoku_history_book = Book.find_by(id: SeidokuHistory.last.book_id)
        # 精読メモが多い順のbook_id。1-3位まで
        seidoku_memo_ranking = SeidokuMemo.group(:book_id).order('count(book_id) desc').pluck(:book_id)[0..2]

        #「前回の続き」用
        @seidoku_history =
          { title: seidoku_history_book.title,
            randoku_imgs_count: seidoku_history_book.randoku_imgs.count,
            randoku_memos_count: seidoku_history_book.randoku_memos.count,
            seidoku_memos_count: seidoku_history_book.seidoku_memos.count,
            reading_state: case seidoku_history_book.reading_state
            when State::READING_STATE.key("乱読")
              "乱読"
            when State::READING_STATE.key("精読")
              "精読"
            else
              "通読"
            end,
            path: SeidokuHistory.last.path,
            seidoku_history_ranking: seidoku_memo_ranking.include?(seidoku_history_book.id) ?
            seidoku_memo_ranking.index(seidoku_history_book.id) : "" }
      end

      # 全ての乱読画像合計数
      @all_randoku_imgs_count =
        all_randoku_state_books.reduce(0) do |accumulator, book|
          accumulator + book.randoku_imgs.count
        end

      # 精読メモが多い順
      seidoku_memos_desc_of_seidoku_state_books =
        all_seidoku_state_books.find(
          SeidokuMemo.group(:book_id).order('count(book_id) desc').pluck(:book_id)
      )
      @seidoku_memos_desc_of_seidoku_state_books =
        seidoku_memos_desc_of_seidoku_state_books.map do |book|
          { titile: book.title, randoku_imgs_count: book.randoku_imgs.count, seidoku_memos_count: book.seidoku_memos.count }
        end

      # 精読メモの投稿順
      created_seidoku_memos_desc_of_seidoku_state_books =
        all_seidoku_state_books.find(
          SeidokuMemo.order('created_at desc').pluck(:book_id)
      )
      @created_seidoku_memos_desc_of_seidoku_state_books =
        created_seidoku_memos_desc_of_seidoku_state_books.map do |book|
          { titile: book.title, randoku_imgs_count: book.randoku_imgs.count, seidoku_memos_count: book.seidoku_memos.count }
        end

      # 精読本の投稿順
      created_books_desc_of_seidoku_state_books =
        all_seidoku_state_books.find(
          Book.all.order('created_at desc').pluck(:id)
      )
      @created_books_desc_of_seidoku_state_books =
        created_books_desc_of_seidoku_state_books.map do |book|
          { titile: book.title, randoku_imgs_count: book.randoku_imgs.count, seidoku_memos_count: book.seidoku_memos.count }
        end
    end
  end
end
