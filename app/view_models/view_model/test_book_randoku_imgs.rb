module ViewModel

  class TestBookRandokuImgs
    attr_reader :title, :randoku_imgs_all

    def initialize(book:)
      @title = book.title
      @randoku_imgs_all =
        book.randoku_imgs.all.order(updated_at: :desc).to_a.map { |img|
          {
            id: img.id,
            updated_at: I18n.l(img.updated_at, format: :short),
            name: img.name,
            # path: "public/#{book.id}/#{page_img_name}",
            # thumbnail_path: "public/#{book.id}/thumb/sm_#{page_img_name}"
            path: "/#{book.id}/#{img.name}",
            thumbnail_path: "/#{book.id}/thumb/sm_#{img.name}",

          }
        }
    end
  end
end

