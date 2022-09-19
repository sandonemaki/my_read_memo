class BookPages::ImgsController < ApplicationController
  require 'tmpdir'
  require 'fileutils'

  def create
    if params[:page_imgs]
      page_imgs = params[:page_imgs]
      book = Book.find_by(id: params[:book_id])
      page_img_names = []

      FileUtils.mkdir_p("public/#{book.id}/")
      # ファイル名の保存
      page_imgs.each_with_index do |page_img|
        page_img_extname = File.extname(page_img.original_filename)
        if page_img_extname.match("\.HEIC$|\.heic$")
          jpg_imgname =
            "public/#{book.id}/#{page_img.original_filename.sub(/.HEIC$|.heic$/, ".jpg")}"
          page_img_names << jpg_imgname

          # 実体の保存
          Dir.mktmpdir do |tmpdir|
            File.binwrite("#{tmpdir}/#{page_img.original_filename}", page_img.read)
            system('magick modrify -format jpg '+tmpdir+'/*.HEIC')
            FileUtils.mv(Dir.glob("#{tmpdir}/*jpg"), "public/#{book.id}/")
          end


        end
      end
    end
  end
end
