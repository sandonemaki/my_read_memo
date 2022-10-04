class BookPages::ImgsController < ApplicationController
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

        if page_img_extname.match("\.HEIC$|\.heic$")
          jpg_imgname =
            page_img.original_filename.sub(/.HEIC$|.heic$/, ".jpg")
          page_img_names << jpg_imgname

          # 用途
          # -本画像の実体を保存 temp/
          # -Exif 情報の削除
          # -heic->jpg に変換
          # -thumb の実体を保存 public/book.id/thumb/
          # -本画像を移動 temp/ -> public/book.id
          # -temp/ 消去

          Dir.mktmpdir { |tmpdir|
            File.binwrite("#{tmpdir}/#{page_img.original_filename}", page_img.read)
            system('mogrify -strip '+tmpdir+'/*')
            system('magick mogrify -format jpg '+tmpdir+'/*.HEIC')
            file_name = file.gsub(/#{tmpdir}\//, '')
            system('convert '+tmpdir+'/*.jpg -thumbnail 220x150 -gravity North \
              -extent 220x150 public/'+book.id+'/thumb/sm_'+file_name)
            FileUtils.mv(Dir.glob("#{tmpdir}/*jpg"), "public/#{book.id}/")
          }

          # 用途
          # -ファイル名の取得
        elsif page_img_extname.downcase.match(/.jpg$|.jpeg$|.png$|.pdf$/)
          page_img_names << page_img.original_filename

          # 用途
          # -本画像の実体を保存 temp/
          # -Exif 情報の削除
          # -thumbの実体の保存 public/book.id/thumb/
          # -本画像を移動 temp/ -> public/book.id
          # -temp/ 消去

          Dir.mktmpdir { |tmpdir|
            File.binwrite("#{tmpdir}/#{page_img.original_filename}", page_img.read)
            system('mogrify -strip '+tmpdir+'/*')
            size = "220x150"
            system('convert '+tmpdir+'/* -thumbnail '+size+' -gravity North -extent '+size+' public/'+book.id.to_s+'/thumb/sm_'+page_img.original_filename)
            FileUtils.mv(Dir.glob("#{tmpdir}/*"), "public/#{book.id}/")
          }
        else
          flash[:notice] = "指定の拡張子で画像を投稿してください"
          redirect_to(controller: :book_pages, action: :show)
        end
      }
      each_randoku_imgs_and_first_flag_save(book, randoku_imgs, page_img_names)
    else
      show_view_model_for_book(book, randoku_imgs)
    end
  end # def create

  # 用途
  # - 乱読画像名/パスの保存
  # - 初登校画像flagの保存

  def each_randoku_imgs_and_first_flag_save(book, randoku_imgs, page_img_names)
    page_img_names_save = []
    page_img_names.each { |page_img_name|
      if book.randoku_imgs.exists?(name: page_img_name)
        randoku_img_record = book.randoku_imgs.find_by(name: page_img_name)
        show_view_model_for_book(book, randoku_imgs) unless randoku_img_record.update(name: page_img_name)
      else
        randoku_imgs.name = page_img_name
        randoku_imgs.path =  "public/#{book.id}/#{page_img_name}"
        randoku_imgs.thumbnail_path = "public/#{book.id}/thumb/sm_#{page_img_name}"
        show_view_model_for_book(book, randoku_imgs) unless randoku_imgs.save
      end
    }
    # 用途
    # 最初の投稿
    # first_post_flag == 1
    if book.randoku_imgs.exists?(id: 1)
      randoku_img_id_1 = book.randoku_imgs.find_by(id:1)
      randoku_img_id_1.first_post_flag = 1 if randoku_img_id_1.first_post_flag == 0
      unless randoku_img_id_1.save
        show_view_model_for_book(book, randoku_imgs)
      end
    end

    flash[:notice] = "画像を保存しました"
    redirect_to("/book_pages/#{book.id}")
  end

  # 用途
  # - インスタンスをviewから参照できるようにする
  def show_view_model_for_book(book, randoku_imgs)
    flash.now[:danger] = "保存できませんでした"
    book_id = book.id
    book_title = book.title
    book_author_1 = book.author_1
    book_author_2 = book.author_2
    book_publisher = book.publisher
    book_total_page = book.total_page
    book_errors = book.errors
    files = randoku_imgs.files(book)
    count = randoku_imgs.reading_state_count(book)
    read_again = count[:read_again]
    finish_read = count[:finish_read]
    show_book_view_model =
      BookViewModel::ShowViewModel.new(
        id: book_id,
        title: book_title,
        author_1: book_author_1,
        author_2: book_author_2,
        publisher: book_publisher,
        total_page: book_total_page,
        errors: book_errors,
    )
    show_randoku_imgs_view_model =
      RandokuImgViewModel::ShowViewModel.new(
        files: files,
        read_again: read_again,
        finish_read: finish_read
    )
    render("show", locals: {book: show_book_view_model, randoku_img: show_randoku_imgs_view_model})
  end
end
