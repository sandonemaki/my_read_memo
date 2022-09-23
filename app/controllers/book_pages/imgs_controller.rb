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
      page_imgs.each do |page_img|
        page_img_extname = File.extname(page_img.original_filename)
        # ファイル名の保存
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
          # ファイル名の保存
        elsif page_img_extname.downcase.match.(/.jpg$|.jpeg$|.png$|.pdf$/)
          page_img_names << "public/#{book.id}/#{page_files.original_filename}"
          # 実体の保存
          File.binwrite("public/#{book.id}/#{page_file.original_filename}", page_img.read)
        else
          flash[:notice] = "指定の拡張子で画像を投稿してください"
          redirect_to(controller: :book_pages, action: :show)
        end
      end

      # DBに保存
      each_randoku_imgs_save(randoku_img, page_img_names)

      else
        book_for_show_view_model(book)
      end
    else
      book_for_show_view_model(book)
    end
  end # def create

  def each_randoku_imgs_save(book, randoku_img, page_img_names: [])
    page_img_names_save = []
    page_img_names.each do |page_img_name|
      randoku_img.name = page_img_name
      randoku_img.path = "public/#{book.id}/page_img_name"
      page_img_names_save << randoku_img.save
    end
    if page_img_name_save.length == page_img_names.length
      randoku_img_id_1 = randoku_img.find_by(id: 1)
      randoku_first_post_flag(book, randoku_img_id_1)
    else
      book_for_show_view_model(book)
    end
  end

  def randoku_first_post_flag(book, randoku_img_id_1)
    if randoku_img_id_1.first_post_flag == 0
      randoku_img_id_1.first_post_flag = 1
      if randoku_img_id_1.save
        flash[:notice] = "画像を保存しました"
        redirect_to("/book_pages/#{book.id}")
      else
        book_for_show_view_model(book)
      end
    else
      flash[:notice] = "画像を保存しました"
      redirect_to("/book_pages/#{book.id}")
    end
  end

  def book_for_show_view_model(book)
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
