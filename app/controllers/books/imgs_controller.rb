class Books::ImgsController < ApplicationController
  require 'tmpdir'
  require 'fileutils'

  def toggle_already_read
    book = Book.find_by(id: params[:book_id])
    # randoku_imgsのカラム、reading_state はis_already_readに変更予定
    book.randoku_imgs.find_by(id: params[:id]).reading_state = img_params[:alreadyread_toggle]
    if book.save
      render json: { status: :ok }
    else
      render json: { status: 500 }
    end
  end

  def create
    if params[:page_imgs]
      page_imgs = params[:page_imgs]
      book = Book.find_by(id: params[:book_id])

      FileUtils.mkdir_p("public/#{book.id}/")
      FileUtils.mkdir_p("public/#{book.id}/thumb/")

      # DBに保存するためのファイル名を追加
      filenames_save_db = []

      page_imgs.each { |page_img|
        page_img_extname = File.extname(page_img.original_filename)

        # 用途
        # -ファイル名の取得

        if page_img_extname.match(".HEIC$|.heic$")
          jpg_imgname =
            page_img.original_filename.sub(/.HEIC$|.heic$/, ".jpg").gsub(" ", "")
          filenames_save_db << jpg_imgname
          save_image_entity_after_convert_from_hiec_to_jpg(page_img, jpg_imgname)#メソッド呼び出し

          # 用途
          # -ファイル名の取得
        elsif page_img_extname.downcase.match(/.jpg$|.jpeg$|.png$|.pdf$/)
          filename = "#{page_img.original_filename.gsub(" ", "")}"
          filenames_save_db << filename
          save_image_entity_after_convert_to_jpg(book, page_img, filename) #メソッド呼び出し1

        else
          flash[:notice] = "指定の拡張子で画像を投稿してください"
          redirect_to(controller: :books, action: :show)
        end
      }
      db_save_randoku_imgs(book, filenames_save_db)
    else
      flash.now[:danger] = "保存できませんでした"
      # Todo:保存できなかったときのviewmodelを作成する
    end
  end # def create

  # 用途
  # -本画像の実体を保存 temp/
  # -Exif 情報の削除
  # -heic->jpg に変換
  # -thumb の実体を保存 public/book.id/thumb/
  # -本画像を移動 temp/ -> public/book.id
  # -temp/ 消去
  def save_image_entity_after_convert_from_hiec_to_jpg(boook, page_img, jpg_imgname)
    size = "220x150"
    Dir.mktmpdir { |tmpdir|
      File.binwrite("#{tmpdir}/#{jpg_imgname}", page_img.read)
      system('mogrify -strip '+tmpdir+'/"*"')
      system('magick mogrify -format jpg '+tmpdir+'/*.HEIC')
      system('convert '+tmpdir+'/*.jpg -thumbnail '+size+' -gravity North \
             -extent '+size+' public/'+book.id.to_s+'/thumb/sm_'+jpg_imgname)
      FileUtils.mv(Dir.glob("#{tmpdir}/*jpg"), "public/#{book.id}/")
    }
  end

  # 用途
  # -本画像の実体をpng -> jpgに変換して保存 temp/
  # -Exif 情報の削除
  # -サイズを変更してthumbnailとして実体の保存 public/book.id/thumb/
  # -本画像を移動 temp/ -> public/book.id
  # -temp/ 消去
  def save_image_entity_after_convert_to_jpg(book, page_img, filename)
    size = "220x150"
    Dir.mktmpdir { |tmpdir|
      File.binwrite("#{tmpdir}/#{filename}", page_img.read)
      system('mogrify -format jpg *.png')
      system('mogrify -strip '+tmpdir+'/*')
      system('convert '+tmpdir+'/* -thumbnail '+size+' -gravity North \
             -extent '+size+' public/'+book.id.to_s+'/thumb/sm_'+filename)
      FileUtils.mv(Dir.glob("#{tmpdir}/*jpg"), "public/#{book.id}/")
    }
  end

  def db_save_randoku_imgs(book, filenames_save_db)
    # 用途
    # dbに同じ画像名が存在するかを確認
    # 存在しない場合にパスと画像名を保存
    filenames_save_db.each { |page_img_name|
      randoku_img_record = book.randoku_imgs.find_or_initialize_by(name: page_img_name)
      if randoku_img_record.new_record?
        randoku_img_record.path = "public/#{book.id}/#{page_img_name}"
        randoku_img_record.thumbnail_path = "public/#{book.id}/thumb/sm_#{page_img_name}"
        unless randoku_img_record.save
          flash.now[:danger] = "保存できませんでした"
        # Todo:保存できなかったときのviewmodelを作成する
        end
      else
        # すでに同じ名前の画像がdbに存在する場合
        # MEMO: ニーズがあれば同じ画像名が存在する場合にユーザーに質問した上でupdateする場合はupdateするようにしたい
        flash.now[:warning] = "#{page_img_name}はすでに存在します。別の名前で保存してください"
      end
    }
    save_first_post_flag(book)

    flash[:notice] = "画像を保存しました"
    redirect_to("/books/#{book.id}")
  end

  # 用途
  # 最初の投稿
  # first_post_flag == 1
  def save_first_post_flag(book)
    return if book.randoku_imgs.exists?(first_post_flag: 1)
    randoku_img = book.randoku_imgs.order(:created_at).first
    randoku_img.update(first_post_flag: 1) if randoku_img.present?
  end

  private

  def img_params
    params.permit(:alreadyread_toggle)
  end


end
