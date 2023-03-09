module ViewModel

  class TestBookRandokuImgs
    attr_reader :title, :randoku_imgs_all

    def initialize(book:)
      @title = book.title
      @randoku_imgs_all =
        book.randoku_imgs.all.order(updated_at: :desc).to_a.map { |img|
          ViewModel::RandokuImg.new(img: img, book: book)
        }
      end
    end


  class RandokuImg
    attr_reader :id, :name, :updated_at, :path, :thumbnail_path

    def initialize(img:, book:)
      @id = img.id
      @namei = img.name
      @updated_at = I18n.l(img.updated_at, format: :short)
      @path = "/#{book.id}/#{img.name}"
      @thumbnail_path = "/#{book.id}/thumb/sm_#{img.name}"
    end
  end
end
