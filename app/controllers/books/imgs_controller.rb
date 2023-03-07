class Books::ImgsController < ApplicationController
  require 'tmpdir'
  require 'fileutils'

  def create
    if params[:page_imgs]
      page_imgs = params[:page_imgs]
      book = Book.find_by(id: params[:book_id])
      randoku_imgs = book.randoku_imgs.new
      page_img_names = []

      FileUtils.mkdir_p("public/#{book.id}/")
      FileUtils.mkdir_p("public/#{book.id}/thumb/")
      page_imgs.each { |page_img|
        page_img_extname = File.extname(page_img.original_filename)

        # 用途
        # -ファイル名の取得

        if page_img_extname.match(".HEIC$|.heic$")
          jpg_imgname =
            page_img.original_filename.sub(/.HEIC$|.heic$/, ".jpg").gsub(" ", "")
          page_img_names << jpg_imgname

          # 用途
          # -本画像の実体を保存 temp/
          # -Exif 情報の削除
          # -heic->jpg に変換
          # -thumb の実体を保存 public/book.id/thumb/
          # -本画像を移動 temp/ -> public/book.id
          # -temp/ 消去

          Dir.mktmpdir { |tmpdir|
            File.binwrite("#{tmpdir}/#{jpg_imgname}", page_img.read)
            system('mogrify -strip '+tmpdir+'/"*"')
            system('magick mogrify -format jpg '+tmpdir+'/*.HEIC')
            system('convert '+tmpdir+'/*.jpg -thumbnail 220x150 -gravity North \
                   -extent 220x150 public/'+book.id.to_s+'/thumb/sm_'+jpg_imgname)
            FileUtils.mv(Dir.glob("#{tmpdir}/*jpg"), "public/#{book.id}/")
          }

          # 用途
          # -ファイル名の取得
        elsif page_img_extname.downcase.match(/.jpg$|.jpeg$|.png$|.pdf$/)
          filename = "#{page_img.original_filename.gsub(" ", "")}"
          page_img_names << filename

          # 用途
          # -本画像の実体を保存 temp/
          # -Exif 情報の削除
          # -thumbの実体の保存 public/book.id/thumb/
          # -本画像を移動 temp/ -> public/book.id
          # -temp/ 消去

          size = "220x150"
          Dir.mktmpdir { |tmpdir|
            File.binwrite("#{tmpdir}/#{filename}", page_img.read)
            system('mogrify -format jpg *.png')
            system('mogrify -strip '+tmpdir+'/*')
            system('convert '+tmpdir+'/* -thumbnail '+size+' -gravity North \
                   -extent '+size+' public/'+book.id.to_s+'/thumb/sm_'+filename)
            FileUtils.mv(Dir.glob("#{tmpdir}/*"), "public/#{book.id}/")
          }
        else
          flash[:notice] = "指定の拡張子で画像を投稿してください"
          redirect_to(controller: :book_pages, action: :show)
        end
      }
      each_randoku_imgs_and_first_flag_save(book, randoku_imgs, page_img_names)
    else
      flash.now[:danger] = "保存できませんでした"
      # Todo:保存できなかったときのviewmodelを作成する
    end
  end # def create

  def each_randoku_imgs_and_first_flag_save(book, randoku_imgs, page_img_names)
    page_img_names_save = []
    page_img_names.each { |page_img_name|
      if book.randoku_imgs.exists?(name: page_img_name)
        randoku_img_record = book.randoku_imgs.find_by(name: page_img_name)
        unless randoku_img_record.update(name: page_img_name)
          flash.now[:danger] = "保存できませんでした"
          # Todo:保存できなかったときのviewmodelを作成する
          # show_view_model_for_book_pages(book, randoku_imgs)
        end
      else
        new_randoku_img = book.randoku_imgs.new(
          name: page_img_name,
          path: "public/#{book.id}/#{page_img_name}",
          thumbnail_path: "public/#{book.id}/thumb/sm_#{page_img_name}",
        )
        unless new_randoku_img.save
          flash.now[:danger] = "保存できませんでした"
          # show_view_model_for_book_pages(book, randoku_imgs)
          # Todo:保存できなかったときのviewmodelを作成する
        end
      end
    }
    # 用途
    # 最初の投稿
    # first_post_flag == 1
    if book.randoku_imgs.exists?(id: 1)
      randoku_img_id_1 = book.randoku_imgs.find_by(id:1)
      randoku_img_id_1.first_post_flag = 1 if randoku_img_id_1.first_post_flag == 0
      unless randoku_img_id_1.save
        flash.now[:danger] = "保存できませんでした"
        # show_view_model_for_book_pages(book, randoku_imgs)
        # Todo:保存できなかったときのviewmodelを作成する
      end
    end

    flash[:notice] = "画像を保存しました"
    redirect_to("/books/#{book.id}")
  end
end
