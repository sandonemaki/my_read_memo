module State
  class ReadingStatus
    attr_reader :randoku_imgs_count, :book_total_pages

    def initialize(book:)
      @book_total_pages = book.total_page
      # Todo: randoku_imgsのカラム「reading_state」はis_already_readに変更予定
      @randoku_imgs_count = book.randoku_imgs.group('reading_state').size
    end
  end
end
