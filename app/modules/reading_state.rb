module State
  class ReadingStatus
    attr_reader :randoku_imgs_count, :book_total_pages

    def initialize(book:)
      @book_total_pages = book.total_page
      @randoku_imgs_count = book.randoku_imgs.group('reading_state').size
    end
  end
end
