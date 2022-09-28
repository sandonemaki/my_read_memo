class BookPages::ImgsController < ApplicationController
  require 'tmpdir'
  require 'fileutils'

  def create
    if params[:page_imgs]
      page_imgs = params[:page_imgs]
      book = Book.find_by(id: params[:book_id])
      randoku_img = book.randoku_imgs.new
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
            system('convert '+tmpdir+'/* -thumbnail 220x150 -gravity North \
              -extent 220x150 public/'+book.id+'/thumb/sm_'+page_img.original_filenam)
            FileUtils.mv(Dir.glob("#{tmpdir}/*"), "public/#{book.id}/")
          }
        else
          flash[:notice] = "指定の拡張子で画像を投稿してください"
          redirect_to(controller: :book_pages, action: :show)
        end
      }
      each_randoku_imgs_and_first_flag_save(book, randoku_img, page_img_names)
    else
      show_view_model_for_book(book)
    end
  end # def create

  # 用途
  # - 乱読画像名/パスの保存
  # - 初登校画像flagの保存

  def each_randoku_imgs_and_first_flag_save(book, randoku_img, page_img_names)
    page_img_names_save = []
    page_img_names.each { |page_img_name|
      randoku_img.name = page_img_name
      randoku_img.path = "public/#{book.id}/page_img_name"
      page_img_names_save << randoku_img.save
    }
    if book.randoku_imgs.exists?(id: 1)
      randoku_img_id_1 = book.randoku_imgs.find_by(id:1)
      randoku_img_id_1.first_post_flag = 1 if randoku_img_id_1.first_post_flag == 0
    end

    if (page_img_names_save.length == page_img_names.length && randoku_img_id_1.save) || page_img_names_save.length == page_img_names.length
      flash[:notice] = "画像を保存しました"
      redirect_to("/book_pages/#{book.id}")
    else
      book_for_show_view_model(book)
    end
  end

  # 用途
  # - インスタンスをviewから参照できるようにする

  def show_view_model_for_book(book)
    flash.now[:danger] = "保存できませんでした"
    book_id = book.id
    book_title = book.title
    book_author_1 = book.author_1
    book_author_2 = book.author_2
    book_publisher = book.publisher
    show_book_view_model =
      BookViewModel::ShowViewModel.new(
        id: book_id,
        title: book_title,
        author_1: book_author_1,
        author_2: book_author_2,
        publisher: book_publisher,
        total_page: book_total_page,
    )
    render("show", locals: {book: show_book_view_model})
  end
end
