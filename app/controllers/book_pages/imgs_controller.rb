class BookPages::ImgsController < ApplicationController
  require 'tmpdir'
  require 'fileutils'

  def create
    if params[:page_imgs]
      page_imgs = params[:page_imgs]
      book = Book.find_by(id: params[:book_id])
      page_image_names = []

      # public下にbook_idで全てのディレクトリを作成
      FileUtils.mkdir_p("public/#{book.id}/")
      page_imgs.each do |page_img|
        page_img_extname = File.extname(page_img.original_filename)
        if page_img_extname.match("\.HEIC$|\.heic$")
          jpg_imgname =
            "public/#{book.id}/#{page_img.original_filename.sub(/.HEIC$|.heic$/, ".jpg")}"
        end
      end
    end
  end
end
