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

      seidoku_history = Book.find_by(id: SeidokuHistory.last.book_id) if SeidokuHistory.last.present?

      # 精読中の本の中から精読メモが多い順のbook_id。1-3位まで
      seidoku_memo_ranking = all_seidoku_state_books.joins(:seidoku_memos)
        .group('book.id')
        .select('books.id, COUNT(seidoku_memos.id) as count')
        .order('COUNT(seidoku_memos.id) DESC').limit(3).pluck(:id)

      #「前回の続き」用
      @seidoku_history =
        { title: seidoku_history.title,
          randoku_imgs_count: seidoku_history.randoku_imgs.count,
          randoku_memos_count: seidoku_history.randoku_memos.count,
          seidoku_memos_count: seidoku_history.seidoku_memos.count,
          reading_state: case seidoku_history.reading_state
          when State::READING_STATE.key("乱読")
            "乱読"
          when State::READING_STATE.key("精読")
            "精読"
          else
            "通読"
          end,
          path: SeidokuHistory.last.path,
          seidoku_history_ranking: seidoku_memo_ranking.include?(seidoku_history.id) ?
          seidoku_memo_ranking.index(seidoku_history.id)+1 : ""
        }

      # 全ての乱読画像合計数
      @all_randoku_imgs_count =
        Book.includes(:randoku_imgs).where.not(reading_state: "1").sum("randoku_imgs.id")

      # 現在精読ステータス中の本の中から精読メモの数が多い順に並べる
      seidoku_memos_desc_of_seidoku_state_books =
        all_seidoku_state_books.joins(:seidoku_memos)
        .group('books.id')
        .select('books.*, COUNT(seidoku_memos.id) as seidoku_memos_count')
        .order('seidoku_memos_count DESC')


      #TODO: ハッシュをクラスにする
      @seidoku_memos_desc_of_seidoku_state_books =
        seidoku_memos_desc_of_seidoku_state_books.map do |book|
          {
            titile: book.title,
            randoku_imgs_count: book.randoku_imgs.count,
            seidoku_memos_count: book.seidoku_memos.count
          }
        end

      # 精読メモの投稿順
      created_seidoku_memos_desc_of_seidoku_state_books =
        all_seidoku_state_books.find(
          SeidokuMemo.order('created_at desc').pluck(:book_id)
        )
      #TODO: ハッシュをクラスにする
      @created_seidoku_memos_desc_of_seidoku_state_books =
        created_seidoku_memos_desc_of_seidoku_state_books.map do |book|
          {
            titile: book.title,
            randoku_imgs_count: book.randoku_imgs.count,
            seidoku_memos_count: book.seidoku_memos.count
          }
        end

      # 精読本の投稿順
      created_books_desc_of_seidoku_state_books =
        all_seidoku_state_books.find(
          Book.order('created_at desc').pluck(:id)
        )
      #TODO: ハッシュをクラスにする
      @created_books_desc_of_seidoku_state_books =
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
