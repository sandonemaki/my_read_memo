module State
  class ReadingStatus
    attr_reader :randoku_imgs_count, :book_total_pages

    def initialize(book:)
      @book_total_pages = book.total_page
      # Todo: randoku_imgsのカラム「reading_state」はis_already_readに変更予定
      @randoku_imgs_count = book.randoku_imgs.group('reading_state').size
    end

    def calculated_reading_status
      return State::READING_STATE.key("乱読") if randoku_status?
      return State::READING_STATE.key("精読") if seidoku_status?
      State::READING_STATE.key("通読")
    end

    def randoku_status?
      randoku_imgs_count < book_total_pages / 8
    end
  end
end
