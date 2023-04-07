class Books::ImgsController < ApplicationController
  require 'tmpdir'
  require 'fileutils'

  def toggle_already_read
    book = Book.find_by(id: params[:book_id])
    # randoku_imgsのカラム、reading_state はis_already_readに変更予定
    book.randoku_imgs.find_by(id: params[:id]).reading_state = img_params[:alreadyread_toggle]
    if !book.save
      render json: { status: 500, message: "情報が更新されませんでした。もう一度お試しください" }
      return
    end

    result = book.try_update_reading_state
    if result[:updated] == true
      book_state_updated_info = State::READING_STATE[book.randoku_imgs.reading_state]
      render json: { status: :ok, book_state_updated_info: book_state_updated_info }
    elsif result[:updated] == false
      render json: { status: 502, message: "本のステータスの更新ができませんでした。もう一度お試しください" }
    else
      render json: { status: :ok }
    end

  end


  def create
    if params[:page_imgs]
      page_imgs = params[:page_imgs]
      book = Book.find_by(id: params[:book_id])

      begin
        FileUtils.mkdir_p("public/#{book.id}/")
        FileUtils.mkdir_p("public/#{book.id}/thumb/")
      rescue StandardError => e
        flash[:danger] = "ディレクトリの作成に失敗しました: #{e.message}"
      end
      # DBに保存するためのファイル名を追加
      filenames_save_db = []
      # 最後にerror_messageをまとめて表示
      error_messages = []

      page_imgs.each { |page_img|
        # オリジナルファイル名を非ASCII文字をASCII近似値で置き換え
        filename = ActiveSupport::Inflector
          .transliterate(page_img.original_filename)
          .gsub(" ", "")).gsub(/[^\w.]+/, '_')

        img_ext = File.extname(filename)

        # 用途
        # -ファイル名の取得
        if img_ext.match(".HEIC$|.heic$")
          jpg_imgname =
            filename.sub(/.HEIC$|.heic$/, ".jpg")
          filenames_save_db << jpg_imgname
          save_image_entity_after_convert_from_hiec_to_jpg(page_img, jpg_imgname)#メソッド呼び出し

          # 用途
          # -ファイル名の取得
        elsif img_ext.downcase.match(/.jpg$|.jpeg$|.png$|.pdf$/)
          filenames_save_db << filename
          save_image_entity_after_convert_to_jpg(book, page_img, filename) #メソッド呼び出し1

        else
          error_messages << "#{filename}の拡張子が不正です"
        end
      }
      db_save_randoku_imgs(book, filenames_save_db)

      if error_messages.empty?
        redirect_to("/books/#{book.id}")
      else
        flash.now[:danger] = "アップロードに失敗：\n#{error_messages.join('\n')}"
        book_view_model = ViewModel::BooksShow.new(book: book)
        render 'book/show', locals: { book: book_view_model }
      end
    else
      flash.now[:danger] = "保存できませんでした"
      book_view_model = ViewModel::BooksShow.new(book: book)
      render 'book/show', locals: { book: book_view_model }
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
      begin
        FileUtils.mv(Dir.glob("#{tmpdir}/*jpg"), "public/#{book.id}/")
      rescue StandardError => e
        flash[:danger] = "ファイル操作に失敗しました: #{e.message}"
      end
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
      begin
        FileUtils.mv(Dir.glob("#{tmpdir}/*jpg"), "public/#{book.id}/")
      rescue StandardError => e
        flash[:danger] = "ファイル操作に失敗しました: #{e.message}"
      end

    }
  end

  def db_save_randoku_imgs(book, filenames_save_db)
    # 用途
    # dbに同じ画像名が存在するかを確認
    # 存在しない場合にパスと画像名を保存
    filenames_save_db.each { |page_img_name|
      max_length = 20
      img_name = (page_img_name.length > max_length) ? page_img_name.slice(0, 20)+'…' : img.name

      error_messages = []
      randoku_img_record = book.randoku_imgs.find_or_initialize_by(name: page_img_name)
      if randoku_img_record.new_record?
        randoku_img_record.path = "public/#{book.id}/#{page_img_name}"
        randoku_img_record.thumbnail_path = "public/#{book.id}/thumb/sm_#{page_img_name}"
        unless randoku_img_record.save
          error_messages << img_name
        end

        flash.now[:notice] = "#{img_name}のアップロード完了"
      else
        # すでに同じ名前の画像がdbに存在する場合
        randoku_img_record.update(updated_at: Time.current)
        flash.now[:notice] = "#{img_name}の上書きアップロード完了"
      end
    }
    save_first_post_flag(book)
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
