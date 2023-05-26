module ViewModel

  class BooksShow
    attr_reader :id, :title, :author, :total_page, :reading_progress,
      :publisher, :errors, :first_post_img_path, :randoku_imgs_unread_count, :randoku_imgs_alreadyread_count,
      :randoku_imgs_file_names, :randoku_imgs_all_count, :randoku_imgs_all,
      :seidoku_line_1, :seidoku_line_2


    # @param book [Book] 本モデル
    def initialize(book:)
      @id = book.id
      @title = book.title
      @author = book.author_1
      @total_page = book.total_page
      @reading_progress =
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

      @first_post_img_path =
        if book.randoku_imgs.exists?(first_post_flag: 1)
          "/#{book.id}/#{book.randoku_imgs.find_by(first_post_flag: 1).name}"
        else
          ""
        end
      @seidoku_line_1 = (book.total_page*(1.0/8.0)).floor
      @seidoku_line_2 = (book.total_page*(1.0/4.0)).floor

      # Hash { 未読 => count, 既読 => count }
      randoku_imgs_group_count = book.randoku_imgs.group('reading_state').size
      @randoku_imgs_unread_count = randoku_imgs_group_count[0] ||= 0 # 未読の数
      @randoku_imgs_alreadyread_count = randoku_imgs_group_count[1] ||= 0 # 既読の数

      # モーダル上で乱読画像を読むためのデータ
      @randoku_imgs_all_count = book.randoku_imgs.all.size
      @randoku_imgs_all =
        book.randoku_imgs.all.order(updated_at: :desc).to_a.map { |img|
          ViewModel::RandokuImg.new(img: img, book: book)
        }
    end
  end


  class RandokuImg
    attr_reader :id, :name, :updated_at, :path, :thumbnail_path, :bookmark_flag, :alreadyread

    def initialize(img:, book:)
      @id = img.id
      max_length = 15
      @name = (img.name.length > max_length) ? img.name.slice(0, 15)+'…' : img.name
      @updated_at = I18n.l(img.updated_at, format: :short)
      @path = "/#{book.id}/#{img.name}"
      @thumbnail_path = "/#{book.id}/thumb/sm_#{img.name}"
      @bookmark_flag = img.bookmark_flag
      @alreadyread = img.reading_state
    end
  end
end
