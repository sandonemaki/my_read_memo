module ViewModel

  class RandokuBooks
    attr_reader :all_randoku_state_books, :all_books_count

    def initialize(all_randoku_state_books:, all_seidoku_state_books:, all_books_count:)
      @all_books_count = all_books_count
      @all_randoku_state_books_count = all_randoku_state_books.count
      @all_seidoku_state_books_count = all_seidoku_state_books.count

      # 全ての乱読画像合計数
      @all_randoku_books_imgs_count =
        all_randoku_state_books.reduce(0) do |accumulator, book|
          accumulator + book.randoku_imgs.count
        end

      # 乱読画像が多い順
      randoku_state_books_imgs_desc =
        all_randoku_state_books.find(
          RandokuImg.group(:book_id).order('count(book_id) desc').pluck(:book_id)
      )
      @randoku_state_books_imgs_desc =
        randoku_state_books_imgs_desc.map do |book|
          { titile: book.title, randoku_imgs_count: book.randoku_imgs.count, randoku_memos_count: book.randoku_memos.count }
        end

      # 乱読画像の投稿順
      randoku_state_books_updated_imgs_desc =
        all_randoku_state_books.find(
          RandokuImg.order('updated_at desc').pluck(:book_id)
      )
      @randoku_state_books_updated_imgs_desc =
        randoku_state_books_updated_imgs_desc.map do |book|
          { titile: book.title, randoku_imgs_count: book.randoku_imgs.count, randoku_memos_count: book.randoku_memos.count }
        end

      # 乱読本の投稿順
      randoku_state_created_books_desc =
        all_randoku_state_books.find(
          Book.all.order('created_at desc').pluck(:id)
      )
      @randoku_state_books_imgs_desc =
        randoku_state_books_imgs_desc.map do |book|
          { titile: book.title, randoku_imgs_count: book.randoku_imgs.count, randoku_memos_count: book.randoku_memos.count }
        end
    end
  end
end
