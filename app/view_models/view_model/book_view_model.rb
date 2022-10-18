module ViewModel

  class BookViewModel
    attr_reader :id, :title, :author_1, :author_2, :total_page, :reading_state,
      :publisher, :errors, :randoku_img_read_again_count, :randoku_img_finish_read_count,
      :randoku_img_file_names

    # @param book [Book] 本モデル
    def initialize(book:)
      @id = book.id
      @title = book.title
      @author_1 = book.author_1
      @author_2 = book.author_2
      @total_page = book.total_page
      @reading_state =
        case book.reading_state
        when State::READING_STATE.key("乱読")
          "乱読"
        when State::READING_STATE.key("精読")
          "精読"
        else
          "通読"
        end
      @publisher = book.publisher
      @errors = book.errors

      reading_state = book.randoku_imgs.group('reading_state').size
      @randoku_img_read_again_count  = reading_state[0] ||= 0 # 未読の数(0)
      @randoku_img_finish_read_count = reading_state[1] ||= 0 # 既読の数(0)
      @randoku_img_file_names = Dir.glob("public/#{book.id}/thumb/*")
        .sort_by { |randoku_img_path| File.mtime(randoku_img_path) }
        .map { |f| f.split("/").last }
        .reverse
    end
  end
end
